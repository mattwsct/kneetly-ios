//
//  AppDelegate.swift
//  Kneetly
//
//  Created by Matt Westcott on 30.11.16.
//  Copyright © 2016 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import GoogleSignIn
import FBSDKLoginKit
import AlamofireNetworkActivityIndicator
import UserNotificationsUI
import UserNotifications
import FirebaseMessaging
import MBProgressHUD

class RootVCContainer: RootNavigationRequestHandler {
    let viewController: UIViewController
    let requestHandler: NavigationRequestHandler?
    
    init(vc: UIViewController) {
        self.viewController = vc
        self.requestHandler = vc.findFirstNavigationRequestHandler()
    }
    
    func handle(navigationRequest: NavigationRequest, completion: () -> ()) {
        self.requestHandler?.handle(navigationRequest: navigationRequest, completion: completion)
    }
}

@UIApplicationMain
open class BaseAppDelegate: UIResponder, UIApplicationDelegate, FIRMessagingDelegate, UNUserNotificationCenterDelegate {
    
    public enum AppState {
        case loading, started
    }
 
    open private (set) var requestSender: RequestSender!
    
    public var window: UIWindow?
    
    private var screenNavigator: ScreenNavigator!
    
    public private(set) var state = AppState.loading 
    
    private var pendingPushNotifications = [NotificationInfo]()
    
    private var appStateProvider: AppStateProvider!
    
    open static func current() -> BaseAppDelegate {
        return UIApplication.shared.delegate as! BaseAppDelegate
    }
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        let loginVCContainer = RootVCContainer(vc: makeLoginViewController())
        let mainVCContainer = RootVCContainer(vc: makeMainViewController())
        
        screenNavigator = ScreenNavigator(loginNavigationHandler: loginVCContainer,
                                          mainScreenNavigationHandler: mainVCContainer,
                                          window: self.window!)
        
        screenNavigator.showLoadingScreen()
        prepareToStart(withLaunchOptions: launchOptions, completion: {
            self.start()
        })
        
        setupAppearance()
        
        return true
    }
    
    public func applicationDidBecomeActive(_ application: UIApplication) {
        if isUserLoggedIn() {
            getCurrentWashFlowState { appState in
                if let state = appState {
                    switch state.appUserStatus! {
                    case .unknown, .noNavigation: break
                    default:
                        if let navigationRequest = self.makeNavigationRequest(withLastAppState: state) {
                            self.showMainScreen(withNavigationRequest: navigationRequest)
                        }
                    }
                }
            }
        }
        clearNotificationCenter(application: application)
    }
    
    open func getCurrentWashFlowState(completion: @escaping (_ lastAppState: LastAppState?) -> Void) {
        fatalError("Subclasses should override this method")
    }
 
    open func setupAppearance() {
        let tabBarItemApperance = UITabBarItem.appearance()
        tabBarItemApperance.setTitleTextAttributes([NSForegroundColorAttributeName : R.color.kneetly.navyTone3()], for: UIControlState.normal)
        tabBarItemApperance.setTitleTextAttributes([NSForegroundColorAttributeName : R.color.kneetly.blue1()], for: UIControlState.selected)
        
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.tintColor = R.color.kneetly.blue1()
    }
    
    open func makeMainViewController() -> UIViewController {
        fatalError("Subclasses should override this method")
    }
    
    open func makeLoginViewController() -> UIViewController {
        fatalError("Subclasses should override this method")
    }
    
    open func makeNavigationRequest(withLastAppState state: LastAppState) -> NavigationRequest? {
        return nil
    }
    
    open func prepareToStart(withLaunchOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?, completion: @escaping ()->()) {
        setupEnvironment(withLaunchOptions: launchOptions, completion: completion)
    }
    
    open func setupEnvironment(withLaunchOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?, completion: @escaping ()->()) {
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        
        FIRApp.configure()
        
        FBSDKApplicationDelegate.sharedInstance().application(UIApplication.shared, didFinishLaunchingWithOptions: launchOptions)
        
        let serverURLString = Bundle.main.object(forInfoDictionaryKey: "ServerURL") as! String
        let apiClient = ApiClient(baseURL: serverURLString)
        apiClient.errorStatusCodeForNotification = ApiErrorCode.invalidAccessToken.rawValue
        apiClient.didReceiveErrorStatusCodeHandler = { _ in
            self.logout()
        }
        self.requestSender = apiClient
        
        appStateProvider = makeAppStateProvider()
        
        AuthentificationManager.sharedInstance.configure(withRequestSender: apiClient, completion: {
            self.appStateProvider.updateState(withCompletion: { (_) in
              completion()
            })
        })
        AuthentificationManager.sharedInstance.newAccessTokenHandler = { token in
            apiClient.constantParameters = ["access_token" : token]
            self.updateFCMToken()
        }
        
        NetworkActivityIndicatorManager.shared.isEnabled = true
        NetworkActivityIndicatorManager.shared.startDelay = 0
        NetworkActivityIndicatorManager.shared.completionDelay = 0
        
        setupPushNotifications()

        MapsService.shared.configure()
    }
    
    private func clearNotificationCenter(application: UIApplication) {
        application.applicationIconBadgeNumber = 1
        application.applicationIconBadgeNumber = 0
        application.cancelAllLocalNotifications()
    }
    
    private func start() {
        self.state = .started
        if self.isUserLoggedIn() {
            self.updateFCMToken()
            self.setScreenBasedOnLastAppState()
        }
        else {
            self.showLoginScreen()
        }
    }
    
    func updateLastAppStateAndResetUI() {
        let hud = MBProgressHUD.showAdded(to: self.window!, animated: true)
        appStateProvider.updateState { (_) in
            self.setScreenBasedOnLastAppState()
            hud.hide(animated: true)
        }
    }
    
    private func setScreenBasedOnLastAppState() {
        if let state = appStateProvider.lastLoadedState, let navigationRequest = makeNavigationRequest(withLastAppState: state) {
            if navigationRequest.screen.requiredScreenPresenter == .loginScreen {
                self.showLoginScreen()
                self.screenNavigator.execute(navigationRequest: navigationRequest)
            }
            else {
                self.showMainScreen(withNavigationRequest: navigationRequest)
            }
        }
        else {
            self.showMainScreen()
            self.checkPendingNotifications()
        }
    }
    
    open func showPostLoginScreen(withCompletion completion: @escaping () -> ()) {
        completion()
    }
    
    open func logout() {
        screenNavigator.showLoginScreen()
        screenNavigator.reset(mainScreenNavigationHandler: RootVCContainer(vc: makeMainViewController()))
       // setRoot(viewController: makeLoginViewController())
    }
    
    open func isUserLoggedIn() -> Bool {
        return AuthentificationManager.sharedInstance.isLoggedIn
    }
    
    open func makeAppStateProvider() -> AppStateProvider {
        fatalError()
    }
    
    //MARK: Navigation
    
    public func showMainScreen(withNavigationRequest request: NavigationRequest? = nil) {
        screenNavigator.showMainScreen()
        
        if let request = request {
            screenNavigator.execute(navigationRequest: request)
        }
    }
    
    public func showLoginScreen() {
        logout()
    }
    
    public func handle(navigationRequest: NavigationRequest)  {
        guard isUserLoggedIn() else {
            return
        }
        
        screenNavigator.execute(navigationRequest: navigationRequest)
    }
    
    //MARK: Push notifications

    private func setupPushNotifications() {
        let application = UIApplication.shared
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            // For iOS 10 data message (sent via FCM)
            FIRMessaging.messaging().remoteMessageDelegate = self
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.tokenRefreshNotification),
                                               name: .firInstanceIDTokenRefresh,
                                               object: nil)
    }
    
    private func updateFCMToken() {
        guard let token = FIRInstanceID.instanceID().token() else {
            return
        }
        
        print("FCM token \(token)")
        
        let request = fcmTokenUpdateRequest(token: token)
        requestSender.sendRequest(apiRequest: request) { (result) in
            switch result {
            case .success(_):
                print("FCM Token updated")
            case .failure(let e):
                print("Failed to update fcm token \(e.message)")
            }
        }
    }
    
    open func fcmTokenUpdateRequest(token: String) -> ApiRequest<ApiObject, ApiErrorCategory<ApiDefaultError>> {
        fatalError()
    }
    
    public func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        didReceivePushNotification(info: remoteMessage.appData)
    }
    
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        didReceivePushNotification(info: userInfo)
    }
    
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        didReceivePushNotification(info: userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    private func checkPendingNotifications() {
        guard let last = pendingPushNotifications.last else {
            return
        }
        
        handle(pushNotification: last)
        pendingPushNotifications.removeAll()
    }
    
    private func didReceivePushNotification(info: NotificationInfo) {
        if state == .loading {
            pendingPushNotifications.append(info)
        }
        else {
            handle(pushNotification: info)
        }
    }

    open func handle(pushNotification: NotificationInfo) {
 
    }
    
    func tokenRefreshNotification(_ notification: Notification) {
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
        }
        
        updateFCMToken()
        connectToFcm()
    }
    
    func connectToFcm() {
        // Won't connect since there is no token
        guard FIRInstanceID.instanceID().token() != nil else {
            return;
        }
        
        // Disconnect previous FCM connection if it exists.
        FIRMessaging.messaging().disconnect()
        
        FIRMessaging.messaging().connect { (error) in
            if error != nil {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    
    @available(iOS 9.0, *)
    open func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handledByGoogle = GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
        
        if handledByGoogle == true {
            return true
        }
        
        let handleByFacebook = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        
        if handleByFacebook == true {
            return true
        }
        
        return false
    }
    
    public func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let handledByGoogle = GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
        
        return handledByGoogle
    }
}


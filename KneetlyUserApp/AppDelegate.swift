//
//  AppDelegate.swift
//  Kneetly
//
//  Created by Matt Westcott on 30.11.16.
//  Copyright © 2016 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import Stripe
import KneetlyCommon
import Branch

@UIApplicationMain

class AppDelegate: BaseAppDelegate {
    
    // MARK: - Deep and universal links
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        let handledByBranch = Branch.getInstance().handleDeepLink(url)
        if handledByBranch {
            return true
        }
        return super.application(app, open: url, options: options)
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        let handledByBranch = Branch.getInstance().continue(userActivity)
        if handledByBranch {
            return true
        }
        return false
    }
    
    override func makeAppStateProvider() -> AppStateProvider {
        let provider = AppStateProvider(requestSender: requestSender, updateRequest: ApiEndpoints.Account.fetchStatusRequest())
        return provider
    }
    
    override func makeNavigationRequest(withLastAppState state: LastAppState) -> NavigationRequest? {
        return ScreenNavigator.navigationRequest(basedOnLastAppState: state)
    }
    
    // MARK: - Environment
    
    override func setupEnvironment(withLaunchOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?, completion: @escaping () -> ()) {
        super.setupEnvironment(withLaunchOptions: launchOptions, completion: completion)
        setupAuthentificationManager()
        STPPaymentConfiguration.shared().publishableKey = AppConfig.Stripe.publishableKey
        Branch.getInstance().initSession(
            launchOptions: launchOptions,
            andRegisterDeepLinkHandler: { params, error in
                if let referralCode = params?[ReferralLink.codeKey] as? String {
                    self.showRegistrationScreen(referralCode: referralCode)
                }
            }
        )
    }
    
    // MARK: - Auth
    override func fcmTokenUpdateRequest(token: String) -> ApiRequest<ApiObject, ApiErrorCategory<ApiDefaultError>> {
        return ApiEndpoints.PushNotification.updateFCMTokenRequest(token: token)
    }
    
    private func setupAuthentificationManager() {
        let config = AppConfig.API.self
        AuthentificationManager.sharedInstance.loginRequestProvider = { token in
            return ApiEndpoints.Account.loginRequest(firebaseToken: token, clientSecret: config.clientSecret, clientId: config.clientID, grantType: config.grantType)
        }
        
        AuthentificationManager.sharedInstance.registerRequestProvider = { token in
            return ApiEndpoints.Account.registerRequest(firebaseToken: token, clientSecret: config.clientSecret, clientId: config.clientID, grantType: config.grantType)
        }
        
        AuthentificationManager.sharedInstance.logoutRequestProvider = { token in
            return ApiEndpoints.Account.logoutRequest(fcmToken: token)
        }
    }
    
    // MARK: - Push notifications
    
    override func handle(pushNotification: NotificationInfo) {
        print(pushNotification)
        guard let notification = UserPushNotificatationParserProvider.parser.parse(notificationInfo: pushNotification) else {
            return
        }

        guard let navigationRequest = ScreenNavigator.navigationRequest(forPushNotification: notification) else {
            return
        }
        
        handle(navigationRequest: navigationRequest)
 
    }
    
    // MARK: - Helpers
    
    override func getCurrentWashFlowState(completion: @escaping (LastAppState?) -> Void) {
        requestSender.sendRequest(apiRequest: ApiEndpoints.WashFlow.getCurrentState()) { result in
            switch result {
            case .success:
                completion(result.value)
            case .failure(_):
                completion(nil)
            }
        }
    }
    
    override func makeMainViewController() -> UIViewController {
        return R.storyboard.main.instantiateInitialViewController()!
    }
    
    override func makeLoginViewController() -> UIViewController {
        return R.storyboard.login.instantiateInitialViewController()!
    }
    
    private func showRegistrationScreen(referralCode: String) {
        if isUserLoggedIn() {
            logout()
        }
        
        let request = NavigationRequest(screen: UserAppScreenCategory.registration(.credentials))
        handle(navigationRequest: request)
    }
}


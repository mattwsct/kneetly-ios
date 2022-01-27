//
//  ScreenNavogator.swift
//  KneetlyCommon
//
//  Created by Andrey Karpets on 2/21/17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation


public struct NavigationRequest {
    public let screen: ScreenCategory
    public let info: [String: Any]?
    
    public init(screen: ScreenCategory) {
        self.screen = screen
        self.info = nil
    }
}

public class ScreenNavigator {
    
    let loginNavigationHandler: RootNavigationRequestHandler
    
    private var mainScreenNavigationHandler: RootNavigationRequestHandler

    let window: UIWindow
    
    init(loginNavigationHandler: RootNavigationRequestHandler, mainScreenNavigationHandler: RootNavigationRequestHandler, window: UIWindow) {
        self.loginNavigationHandler = loginNavigationHandler
        self.mainScreenNavigationHandler = mainScreenNavigationHandler
        self.window = window
    }
    
    func execute(navigationRequest: NavigationRequest) {
        let handler: RootNavigationRequestHandler
        switch navigationRequest.screen.requiredScreenPresenter {
        case .loginScreen:
            handler = loginNavigationHandler
        case .mainScreen:
            handler = mainScreenNavigationHandler
        }
        
        handler.handle(navigationRequest: navigationRequest, completion: {})
    }
    
    func showLoadingScreen() {
        setRoot(viewController: LoadingViewController())
    }
    
    func showMainScreen() {
        setRoot(viewController: mainScreenNavigationHandler.viewController)
    }
    
    func showLoginScreen()  {
        setRoot(viewController: loginNavigationHandler.viewController)
    }
    
    func setRoot(viewController: UIViewController) {
        self.window.rootViewController = viewController
    }
    
    func reset(mainScreenNavigationHandler: RootNavigationRequestHandler) {
        self.mainScreenNavigationHandler = mainScreenNavigationHandler
    }
}

public enum ScreenRequiredPresenter {
    case mainScreen, loginScreen
}

public protocol ScreenCategory {
    var requiredScreenPresenter: ScreenRequiredPresenter { get }
}
 
public protocol NavigationRequestHandler {
    func handle(navigationRequest: NavigationRequest, completion:()->())
}

public protocol RootNavigationRequestHandler: NavigationRequestHandler {
    var viewController: UIViewController { get }
}

open class PushNotificationParser<T: PushNotificationType> {
    
    open var parseImpl: ((_ data: [String: Any], _ type: PushNotificationCategory)->(T?))?
    
    public init() {
        
    }
    
    public func parse(notificationInfo: NotificationInfo) -> PushNotification<T>? {
        guard let data = notificationInfo as? [String: Any] else {
            return nil
        }
        
        guard let category = PushNotificationCategory(JSON: data) else {
            return nil
        }
        
        guard let result = parseImpl?(data, category) else {
            return nil
        }
        
        return PushNotification(isReceivedInBackground: UIApplication.shared.applicationState != .active, type: result)
    }
}


extension UIViewController {
    
    public func findFirstNavigationRequestHandler() -> NavigationRequestHandler? {
        if self is NavigationRequestHandler {
            return self as? NavigationRequestHandler
        }
        
        if self is UINavigationController {
            let nc = self as! UINavigationController
            return nc.viewControllers.first?.findFirstNavigationRequestHandler()
        }
        
        return nil
    }
}

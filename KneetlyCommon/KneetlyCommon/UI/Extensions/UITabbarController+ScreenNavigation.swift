//
//  UITabbarController+ScreenNavigation.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 2/15/17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit

extension UITabBarController {
    
    public func showBadgeScreen(_ screen: BadgeScreen) {
        switch screen {
        case .defaultBadgeScreen(let message, let imageURL):
            KneetlyAlert.showBadgeReceivedNotification(title: message, imageURL: imageURL)
        }
    }
 
    public func showPushNotificationPopup(withMessage message: String) {
        KneetlyAlert.showPushNotificationPopup(withTitle: message, image: Mascot(positive: true).image()!)
    }
    
    
    public func resetAndShowTab(atIndex index: Int) -> Bool {
        guard let nc = navigationController(forTabIndex: index) else {
            return false
        }
        
        selectedViewController = nc
        
        nc.popToRootViewController(animated: false)
        
        return true
    }
    
    public func navigationController(forTabIndex index: Int) -> UINavigationController? {
        return viewControllers?[index] as? UINavigationController
    }
}

//
//  NSNotificationName+Navigation.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 22.02.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation

extension NSNotification.Name {
    
    public struct Navigation {
        
        public static let navigateToLookingForUser = NSNotification.Name(rawValue: "popToLookingForUserNotification")
    }
}

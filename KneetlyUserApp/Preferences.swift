//
//  Preferences.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 11/02/2017.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation

class Preferences {
    private enum Keys: String {
        case  allowStoreLocation = "allowStoreLocationd"
    }
    
    static func setLocationStoreAllowed(_ allow: Bool) {
        UserDefaults.standard.set(allow, forKey: Keys.allowStoreLocation.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    static func isLocationStoreAllowed() -> Bool {
        return UserDefaults.standard.bool(forKey: Keys.allowStoreLocation.rawValue)
    }
}

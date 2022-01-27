//
//  TextView.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 23.01.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import KMPlaceholderTextView

extension KMPlaceholderTextView {
    
    @IBInspectable public var localizedPlaceholderKey: String {
        get {
            return ""
        }
        set {
            placeholder = NSLocalizedString(newValue, tableName: "Localized", comment: "")
        }
    }
    
    @IBInspectable public var localizedTextKey: String {
        get {
            return ""
        }
        set {
            text = NSLocalizedString(newValue, tableName: "Localized", comment: "")
        }
    }
}

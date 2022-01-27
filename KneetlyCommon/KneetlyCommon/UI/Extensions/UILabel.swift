//
//  UILabel.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 12/12/16.
//  Copyright © 2016 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit

extension UILabel {
    @IBInspectable public var localizedTextKey: String {
        get {
            return ""
        }
        set {
            text = NSLocalizedString(newValue, tableName: "Localized", comment: "")
        }
    }
}

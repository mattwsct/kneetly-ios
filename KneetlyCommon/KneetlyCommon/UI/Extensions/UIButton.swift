//
//  UIButton.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 12/12/16.
//  Copyright © 2016 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit

extension UIButton {
    @IBInspectable public var localizedTitleKey: String {
        get {
            return ""
        }
        set {
            setTitle(NSLocalizedString(newValue, tableName: "Localized", comment: ""), for: .normal)
        }
    }
}


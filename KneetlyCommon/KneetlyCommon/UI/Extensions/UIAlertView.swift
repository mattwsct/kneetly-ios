//
//  UIAlertView.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 08.12.16.
//  Copyright © 2016 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation

public extension UIAlertView {
    public static func show(error: Error) {
        show(errorMessage: error.localizedDescription)
    }
    
    public static func show(errorMessage: String) {
        let view = UIAlertView(title: "Error", message: errorMessage, delegate: nil, cancelButtonTitle: "Dismiss")
        view.show()
    }
}

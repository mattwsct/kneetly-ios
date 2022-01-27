//
//  UIViewController+CallSupport.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 13/03/2017.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit

protocol CallSupport {
    func callSupport()
}

extension CallSupport {
    func callSupport() {
        let url = URL(string: "tel://" + R.string.localized.supportPhoneNumber())!
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        }
        else {
            KneetlyAlert.show(errorMessage: R.string.localized.callsUnavailableErrorMessage())
        }
    }
}

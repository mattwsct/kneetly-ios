//
//  ShareService.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 10.02.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import Social
import MessageUI

public enum ShareServiceType {
    case facebook, twitter, sms
    
    public var socialServiceType: String {
        get {
            var result = ""
            switch self {
            case .facebook: result = SLServiceTypeFacebook
            case .twitter: result = SLServiceTypeTwitter
            default: break
            }
            return result
        }
    }
    
    public var serviceUnavailableErrorMessage: String {
        get {
            var result = ""
            switch self {
            case .facebook: result = R.string.localized.shareNoFacebookAccountErrorMessage()
            case .twitter: result = R.string.localized.shareNoTwitterAccountErrorMessage()
            case .sms: result = R.string.localized.shareSmsUnavailableErrorMessage()
            }
            return result
        }
    }
}

open class Share: NSObject, UINavigationControllerDelegate {
    
    static let service = Share()
    
    // MARK: - Interface
    
    open func presentViewController(service: ShareServiceType, sharedText: String) {
        switch service {
        case .facebook,
             .twitter: presentSocialViewController(service: service, sharedText: sharedText)
        case .sms: presentSMSViewController(sharedText: sharedText)
        }
    }
    
    // MARK: - Helpers
    
    private func presentSocialViewController(service: ShareServiceType, sharedText: String) {
        if SLComposeViewController.isAvailable(forServiceType: service.socialServiceType) {
            let shareVC = SLComposeViewController(forServiceType: service.socialServiceType)!
            do {
                try shareVC.add(sharedText.asURL())
            } catch {
                shareVC.setInitialText(sharedText)
            }
            presentViewController(viewController: shareVC)
        } else {
            KneetlyAlert.show(errorMessage: service.serviceUnavailableErrorMessage)
        }
    }
    
    private func presentSMSViewController(sharedText: String) {
        if MFMessageComposeViewController.canSendText() {
            let shareVC = MFMessageComposeViewController()
            shareVC.messageComposeDelegate = self
            shareVC.body = sharedText
            presentViewController(viewController: shareVC)
        } else {
            KneetlyAlert.show(errorMessage: ShareServiceType.sms.serviceUnavailableErrorMessage)
        }
    }
    
    private func presentViewController(viewController: UIViewController) {
        BaseAppDelegate.current().window?.rootViewController?.present(viewController, animated: true, completion: nil)
    }
}

extension Share: MFMessageComposeViewControllerDelegate {
    
    public func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}

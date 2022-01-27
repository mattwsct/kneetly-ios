//
//  RegisterViewController.swift
//  KneetlyUsers
//
//  Created by Matt Westcott on 28.11.16.
//  Copyright © 2016 Be IT Safe Pty Ltd. All rights reserved.
//

import UIKit
import KneetlyCommon

class RegisterViewController: WizardViewController {
    
    enum Pages: Int {
        case credentials = 0
        case profile = 1
        case vehicles = 2
        case paymentMethod = 3
        case paymentTerms = 4
    }
    
    var referralCode: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pages = [
            R.storyboard.login.registerEmailViewController()!,
            R.storyboard.login.registerProfileViewController()!,
            R.storyboard.login.registerVehiclesViewController()!,
            R.storyboard.login.registerPaymentViewController()!,
        ]
        
        self.wizardDelegate = self
        
        if let registerEmailVC = pages.first?.pageViewController as? RegisterEmailViewController {
            registerEmailVC.referralCode = referralCode
        }
    }
    
    func setFirstScreen(screen: ScreenType) {
        switch screen {
        case .updateProfile:
            self.firstPageIndex = Pages.profile.rawValue
        case .addVehicle:
            self.firstPageIndex = Pages.vehicles.rawValue
        case .addCardInfo:
            self.firstPageIndex = Pages.paymentMethod.rawValue
        default:
            break
        }
    }
}

extension RegisterViewController: WizardViewControllerDelegate {
    func wizardDidCanceled(wizard: WizardViewController) {
        
        // FIXME: Remove "_" when UIKit add @discardableResult to this method
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func wizardDidFinished(wizard: WizardViewController) {
        _ = self.navigationController?.popViewController(animated: true)
        AppDelegate.current().showMainScreen()
    }
}

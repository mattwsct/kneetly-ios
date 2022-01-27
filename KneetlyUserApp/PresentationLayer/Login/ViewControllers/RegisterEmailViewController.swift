//
//  Created by Suresh.
//  Copyright © 2016 Be IT Safe Pty Ltd. All rights reserved.
//

import UIKit
import KneetlyCommon
import Firebase
import GoogleSignIn

class RegisterEmailViewController: UIViewController, WizardPage, AuthentificationManagerDelegate, GIDSignInUIDelegate {

    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var referralCode: String?
    
    fileprivate var validator = FormValidator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupValidation()
    }
    
    func setupValidation() {
        validator.setRules(ruleSet: ValidationRules.nonEmpty, forControl: password)
        validator.setRules(ruleSet: ValidationRules.email, forControl: emailAddress)
    }
    
    @IBAction func registerWithGoogle() {
        showProgress()
        AuthentificationManager.sharedInstance.delegate = self
        AuthentificationManager.sharedInstance.loginWithGoogle(inViewController: self)
    }
    
    @IBAction func registerWithFacebook() {
        showProgress()
        AuthentificationManager.sharedInstance.delegate = self
        AuthentificationManager.sharedInstance.loginWithFacebook(inViewController: self)
    }

    // MARK: WizardPage
    
    func nextButtonDidPressed() -> Bool {
        switch validator.validate() {
        case .valid:
            self.showProgress()
            AuthentificationManager.sharedInstance.delegate = self
            AuthentificationManager.sharedInstance.register(email: emailAddress.text!, password: password.text!)
            return true
        case .invalid:
            validator.displayValidationStatus()
            return false
        }
//
    }
    
    func shouldShowCancelButton() -> Bool {
        return true
    }
    
    func isHeaderButtonEnabled(index: Int) -> Bool {
        return false
    }
    
    func continueRegistration(screen: ScreenType?) {
        self.wizardController()?.showNext()
        
        let screenType = screen ?? .unknown
        
        switch screenType {
        case .updateProfile:
            self.wizardController()?.showPage(index: RegisterViewController.Pages.profile.rawValue)
            break
        case .addVehicle:
            self.wizardController()?.showPage(index: RegisterViewController.Pages.vehicles.rawValue)
            break
        default:
            break
        }
    }
    
    // MARK: AuthentificationManagerDelegate

    func authentificationManager(_ manager: AuthentificationManager, didLoggedInWithUser user: FIRUser?) {
        if let referralCode = referralCode {
            AppDelegate.current().requestSender.sendRequest(apiRequest: ApiEndpoints.ReferralRequest.sendReferralCode(referralCode)) { result in
                self.hideProgress()
                switch result {
                case .success(_):
                    self.continueRegistration(screen: .updateProfile)
                case .failure(let error):
                    KneetlyAlert.show(errorMessage: error.message ?? "")
                }
            }
        } else {
            hideProgress()
            continueRegistration(screen: .updateProfile)
        }
    }
    
    func authentificationManager(_ manager: AuthentificationManager, didFailedWithError error: AuthError) {
        hideProgress()
        KneetlyAlert.show(errorMessage: error.description)
    }
    
    func authentificationManagerDidCanceled(_ manager: AuthentificationManager) {
        hideProgress()
    }
}

//
//  Created by Suresh.
//  Copyright © 2016 Be IT Safe Pty Ltd. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

open class BaseLoginViewController: UIViewController,UITextFieldDelegate, GIDSignInUIDelegate {
 
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    let validator = FormValidator()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        setupValidation()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = nil
        passwordTextField.text = nil
    }
    
    func setupValidation() {
        validator.setRules(ruleSet: ValidationRules.email, forControl: emailTextField)
        validator.setRules(ruleSet: ValidationRules.nonEmpty, forControl: passwordTextField)
    }
    
    @IBAction func loginWithFacebook() {
        showProgress()
        AuthentificationManager.sharedInstance.delegate = self
        AuthentificationManager.sharedInstance.loginWithFacebook(inViewController: self)
    }
    
    @IBAction func loginWithGoogle() {
        showProgress()
        AuthentificationManager.sharedInstance.delegate = self
        AuthentificationManager.sharedInstance.loginWithGoogle(inViewController: self)
    }
    
    @IBAction func login() {
        switch validator.validate() {
        case .valid:
            showProgress()
            AuthentificationManager.sharedInstance.delegate = self
            AuthentificationManager.sharedInstance.login(email: emailTextField.text!, password: passwordTextField.text!)
        case .invalid:
            validator.displayValidationStatus()
        }
    }
    
    open func showMainVC() {
        
    }
    
    open func show(screen: ScreenType) {
        
    }
}

extension BaseLoginViewController: AuthentificationManagerDelegate {
    public func authentificationManager(_ manager: AuthentificationManager, didLoggedInWithUser user: FIRUser?) {
        hideProgress()
    
//        if let screenType = screen {
//            show(screen: screenType)
//        } else {
//            showMainVC()
//        }
        
        BaseAppDelegate.current().updateLastAppStateAndResetUI()
    }
    
    public func authentificationManager(_ manager: AuthentificationManager, didFailedWithError error: AuthError) {
        hideProgress()
        KneetlyAlert.show(errorMessage: error.description)
    }
    
    public func authentificationManagerDidCanceled(_ manager: AuthentificationManager) {
        hideProgress()
    }
}

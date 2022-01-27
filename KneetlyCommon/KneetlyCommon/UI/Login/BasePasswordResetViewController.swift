//
//  Created by Matt Westcott.
//  Copyright © 2016 Be IT Safe Pty Ltd. All rights reserved.
//

import UIKit
import Firebase

open class BasePasswordResetViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    let validator = FormValidator()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.setupValidation()
    }
    
    func setupValidation() {
        validator.setRules(ruleSet: ValidationRules.email, forControl: emailTextField)
    }
    
    @IBAction func resetPassword(_ sender: Any) {
        switch validator.validate() {
        case .valid:
            showProgress()
            AuthentificationManager.sharedInstance.sendPasswordReset(email: emailTextField.text!, completion: { error in
                self.hideProgress()
                    if let error = error {
                        KneetlyAlert.show(errorMessage: error.localizedDescription)
                    } else {
                        let _ = self.navigationController?.popViewController(animated: true)
                    }
                })
        case .invalid:
            validator.displayValidationStatus()
        }
    }
}

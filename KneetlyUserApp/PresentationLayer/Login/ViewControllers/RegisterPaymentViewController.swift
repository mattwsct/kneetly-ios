//
//  Created by Suresh.
//  Copyright © 2016 Be IT Safe Pty Ltd. All rights reserved.
//

import UIKit
import KneetlyCommon
import ActiveLabel

class RegisterPaymentViewController: PaymentMethodViewController, WizardPage {
    
    @IBOutlet weak var cardInfo: UITextField!
    
    @IBOutlet weak var termsAndConditionsLabel: ActiveLabel! {
        didSet {
            termsAndConditionsLabel.text = R.string.localized.registrationInfoLabelText()
            let type = ActiveType.custom(pattern: R.string.localized.registrationInfoLabelClickablePart())
            termsAndConditionsLabel.customColor[type] = R.color.kneetly.blue2()
            termsAndConditionsLabel.handleCustomTap(for: type) { [unowned self] _ in
                self.performSegue(withIdentifier: R.segue.registerPaymentViewController.toTermsConditions, sender: nil)
            }
            termsAndConditionsLabel.enabledTypes.append(type)
        }
    }
    
    let validator = FormValidator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupValidation()
    }
    
    // MARK: Validation
    
    private func setupValidation() {
        validator.setRules(ruleSet: ValidationRules.nonEmpty, forControl: cardInfo)
    }
    
    // MARK: WizardPage
    
    func nextButtonTitle() -> String {
        return R.string.localized.registrationAcceptAndConfirmButtonTitle()
    }
    
    func isHeaderButtonEnabled(index: Int) -> Bool {
        return false
    }
    
    func nextButtonDidPressed() -> Bool {
        switch validator.validate() {
        case .valid:
            acceptTermsAndConditions()
            return true
        case .invalid:
            validator.displayValidationStatus()
            return false
        }
    }
    
    // MARK: Actions
    
    @IBAction func cardInfoButtonTapped(_ sender: Any) {
        presentPaymentMethodsViewController(forBusinessId: nil)
    }
    
    // MARK: Requests
    
    private func acceptTermsAndConditions() {
        
        showProgress()
        
        let request = ApiEndpoints.TermsAndConditions.acceptTermsAndConditionsRequest()
        AppDelegate.current().requestSender.sendRequest(apiRequest: request, completion: { (result) in
            
            self.hideProgress()
            
            switch result {
            case .success(_):
                self.wizardController()?.showNext()
            case .failure(let error):
                KneetlyAlert.show(errorMessage: error.message ?? "" )
            }
        })
    }
    
    // MARK: PaymentMethodViewController
    
    override func didReceiveSelectedPaymentMethodName(_ name: String, image: UIImage, forBusinessId: String?) {
        cardInfo.text = name
        cardInfo.displayValidationResult(result: validator.validate())
    }
}

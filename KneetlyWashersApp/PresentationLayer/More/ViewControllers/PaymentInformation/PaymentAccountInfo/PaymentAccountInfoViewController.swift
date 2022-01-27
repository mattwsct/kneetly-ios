//
//  PaymentInformationViewController.swift
//  KneetlyWashersApp
//
//  Created by Matt Westcott on 09.02.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import KneetlyCommon

class PaymentAccountInfoViewController: UIViewController {
    
    @IBOutlet weak var accountNameTextField: UITextField!
    @IBOutlet weak var accountNumberTextField: UITextField!
    @IBOutlet weak var bsbTextField: UITextField!
    @IBOutlet weak var bankTextField: UITextField!
    
    let validator = FormValidator()
    
    var bankAccountInfo: BankAccountInfo?
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupValidation()
        getAccountInfo()
    }
    
    // MARK: - UI
    
    func updateUI() {
        accountNameTextField.text = bankAccountInfo?.accountName
        accountNumberTextField.text = bankAccountInfo?.accountNumber
        bsbTextField.text = bankAccountInfo?.bsb
        bankTextField.text = bankAccountInfo?.bank
    }
    
    // MARK: - Actions
    
    @IBAction func save() {
        switch validator.validate() {
        case .valid:
            updateBankAccountInfo()
        case .invalid:
            validator.displayValidationStatus()
        }
    }
    
    // MARK: - Helpers
    
    private func setupValidation() {
        validator.setRules(ruleSet: ValidationRules.nonEmpty, forControl: accountNameTextField)
        validator.setRules(ruleSet: ValidationRules.bankAccountNumber, forControl: accountNumberTextField)
        validator.setRules(ruleSet: ValidationRules.bsb, forControl: bsbTextField)
        validator.setRules(ruleSet: ValidationRules.nonEmpty, forControl: bankTextField)
    }
    
    private func getAccountInfo() {
        showProgress(forView: view)
        let request = ApiEndpoints.PaymentRequest.getBankAccountInfo()
        AppDelegate.current().requestSender!.sendRequest(
            apiRequest: request,
            completion: { result in
                self.hideProgress(forView: self.view)
                switch result {
                case .success(let bankAccountInfo):
                    self.bankAccountInfo = bankAccountInfo
                    self.updateUI()
                case .failure(let error):
                    KneetlyAlert.show(errorMessage: error.message ?? "")
                }
            }
        )
    }
    
    private func updateBankAccountInfo() {
        showProgress()
        let request = ApiEndpoints.PaymentRequest.updateBankAccountInfo(
            accountName: accountNameTextField.text!,
            accountNumber: accountNumberTextField.text!,
            bsb: bsbTextField.text!,
            bank: bankTextField.text!
        )
        AppDelegate.current().requestSender!.sendRequest(
            apiRequest: request,
            completion: { result in
                self.hideProgress()
                switch result {
                case .success(_): break
                case .failure(let error):
                    KneetlyAlert.show(errorMessage: error.message ?? "")
                }
            }
        )
    }
}

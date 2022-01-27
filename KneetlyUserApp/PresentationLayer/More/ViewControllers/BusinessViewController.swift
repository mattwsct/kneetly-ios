//
//  BusinessViewController.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott Dolzhikova on 07/02/2017.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import UIKit
import KneetlyCommon

class BusinessViewController: UIViewController {
    
    @IBOutlet weak var businessNameTextField: UITextField!
    @IBOutlet weak var abnTextField: UITextField!
    @IBOutlet weak var businessEmailTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var streetAddressTextField: UITextField!
    @IBOutlet weak var suburbTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var postcodeTextField: UITextField!
    
    private let validator = FormValidator()
    
    var business: Business?
    public var didUpdateBusiness : ()->() = { _ in }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupValidation()
        self.updateBusinessInfo()
    }
    
    func setupValidation() {
        validator.setRules(ruleSet: ValidationRules.nonEmpty, forControl: businessNameTextField)
        validator.setRules(ruleSet: ValidationRules.nonEmpty, forControl: abnTextField)
        validator.setRules(ruleSet: ValidationRules.email, forControl: businessEmailTextField)
        validator.setRules(ruleSet: ValidationRules.nonEmpty, forControl: addressTextField)
        validator.setRules(ruleSet: ValidationRules.nonEmpty, forControl: streetAddressTextField)
        validator.setRules(ruleSet: ValidationRules.nonEmpty, forControl: suburbTextField)
        validator.setRules(ruleSet: ValidationRules.nonEmpty, forControl: stateTextField)
        validator.setRules(ruleSet: ValidationRules.nonEmpty, forControl: countryTextField)
        validator.setRules(ruleSet: ValidationRules.nonEmpty, forControl: postcodeTextField)
    }
    
    @IBAction func saveButtonDidPressed(sender: UIButton) {
        switch validator.validate() {
        case .valid:
            self.updateBusiness()
            break
        case .invalid:
            validator.displayValidationStatus()
            break
        }
    }
    
    func updateBusinessInfo() {
        if let business = self.business {
            self.businessNameTextField.text = business.name ?? ""
            self.abnTextField.text = business.abn ?? ""
            self.businessEmailTextField.text = business.email ?? ""
            self.addressTextField.text = business.address ?? ""
            self.streetAddressTextField.text = business.streetaddress ?? ""
            self.suburbTextField.text = business.suburb ?? ""
            self.stateTextField.text = business.state ?? ""
            self.countryTextField.text = business.country ?? ""
            self.postcodeTextField.text = business.postcode ?? ""
        }
    }
    
    func updateBusiness() {
        let parameters = ["name": businessNameTextField.text!, "abn": abnTextField.text!, "email": businessEmailTextField.text!, "address": addressTextField.text!, "streetaddress" : streetAddressTextField.text!, "suburb" : suburbTextField.text!, "state" : stateTextField.text!, "country" : countryTextField.text!, "postcode" : postcodeTextField.text!] as [String : Any]
        
        showProgress()
        
        if let business = self.business {
            let request = ApiEndpoints.Account.updateBusiness(id: business.id, parameters: parameters)
            AppDelegate.current().requestSender!.sendRequest(apiRequest: request, completion: { (result) in
                self.hideProgress()
                switch result {
                case .success( _):
                    self.didUpdateBusiness()
                case .failure( _): break
                }
            })
        } else {
            let request = ApiEndpoints.Account.addBusiness(parameters: parameters)
            AppDelegate.current().requestSender!.sendRequest(apiRequest: request, completion: { (result) in
                self.hideProgress()
                switch result {
                case .success( _):
                    self.didUpdateBusiness()
                case .failure( _): break
                }
            })
        }
    }
    
}

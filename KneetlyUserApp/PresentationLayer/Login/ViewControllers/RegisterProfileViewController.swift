//
//  Created by Suresh.
//  Copyright © 2016 Be IT Safe Pty Ltd. All rights reserved.
//

import UIKit
import KneetlyCommon
import PhoneNumberKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import ActionSheetPicker_3_0
import ActiveLabel

class RegisterProfileViewController: UIViewController, UITextFieldDelegate, WizardPage {
   
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var streetAddressTextField: UITextField!
    @IBOutlet weak var suburbTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var postcodeTextField: UITextField!
    @IBOutlet weak var mobilePhone: PhoneNumberTextField!
    @IBOutlet weak var genderPicker: GenderPicker!
    
    var dateOfBirth: Date?
    
    let validator = FormValidator()
    public var didUpdateProfile : ()->() = { _ in }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupValidation()
        self.fillUserInfo()
        lastNameTextField.setCustomNextTarget(self, action: #selector(RegisterProfileViewController.showDatePicker))
        streetAddressTextField.setCustomPreviousTarget(self, action: #selector(RegisterProfileViewController.showDatePicker))
    }
    
    @IBAction func datePickerClicked(sender: UIButton) {
        showDatePicker()
    }
    
    func showDatePicker() {
        view.endEditing(true)
        let datePicker = ActionSheetDatePicker(title: "Date:", datePickerMode: UIDatePickerMode.date, selectedDate: dateOfBirth ?? Date(), doneBlock: {
            picker, value, index in
            self.dateOfBirth = value as! Date?
            if let dob = self.dateOfBirth {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy"
                self.dateOfBirthTextField.text = formatter.string(from: dob)
            }
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: view)
        
        datePicker?.maximumDate = Date()
        datePicker?.show()
    }
    
    func fillUserInfo() {
        let authentificationType = AuthentificationManager.sharedInstance.authentificationType
        
        switch authentificationType {
        case .facebook:
            self.fetchProfileFromFacebook()
            break
        case .google:
            self.fetchProfileFromGoogle()
            break
        default:
            break
        }
    }
    
    func fetchProfileFromFacebook()
    {
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "gender, first_name, last_name"])
            .start(completionHandler:  { (connection, result, error) in
                if let result = result as? NSDictionary {
                    let first_name = result["first_name"] as? String
                    let last_name = result["last_name"] as? String
                    let user_gender = result["gender"] as? String
                    
                    self.firstNameTextField.text = first_name ?? ""
                    self.lastNameTextField.text = last_name ?? ""
                    self.genderPicker.gender =  (user_gender == "MALE") ? .male : .female
                }
            })
    }
    
    func fetchProfileFromGoogle()
    {
        let user = AuthentificationManager.sharedInstance.googleUser()
        
        let first_name = user?.profile.givenName
        let last_name = user?.profile.familyName
        self.firstNameTextField.text = first_name ?? ""
        self.lastNameTextField.text = last_name ?? ""
    }
    
    func setupValidation() {
        validator.setRules(ruleSet: ValidationRules.nonEmpty, forControl: firstNameTextField)
        validator.setRules(ruleSet: ValidationRules.nonEmpty, forControl: lastNameTextField)
        validator.setRules(ruleSet: ValidationRules.birthday, forControl: dateOfBirthTextField)
        validator.setRules(ruleSet: ValidationRules.nonEmpty, forControl: streetAddressTextField)
        validator.setRules(ruleSet: ValidationRules.nonEmpty, forControl: suburbTextField)
        validator.setRules(ruleSet: ValidationRules.nonEmpty, forControl: stateTextField)
        validator.setRules(ruleSet: ValidationRules.nonEmpty, forControl: countryTextField)
        validator.setRules(ruleSet: ValidationRules.nonEmpty, forControl: postcodeTextField)
        validator.setRules(ruleSet: ValidationRules.phoneNumber, forControl: mobilePhone)
        // validator.setRules(ruleSet: ValidationRules.validGender, forControl: genderPicker)
    }
    
    // MARK: WizardPage

    func nextButtonDidPressed() -> Bool {
        switch validator.validate() {
        case .valid:
            self.updateProfile()
            return true
        case .invalid:
            validator.displayValidationStatus()
            return false
        }
    }
    
    func updateProfile() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        let date = formatter.date(from: dateOfBirthTextField.text!)
        formatter.dateFormat = "yyyy-MM-dd"
        
        var params = ["firstname": firstNameTextField.text!, "lastname": lastNameTextField.text!, "dob": formatter.string(from: date!), "phone": mobilePhone.text!, "streetaddress" : streetAddressTextField.text!, "suburb" : suburbTextField.text!, "state" : stateTextField.text!, "country" : countryTextField.text!, "postcode" : postcodeTextField.text!] as [String : Any]
        
        if genderPicker.gender != .unknown {
            let gender = (genderPicker.gender == .female) ? 1 : 0
            params["gender"] = gender
        }
        
        showProgress()
        let request = ApiEndpoints.Account.updateProfileRequest(parameters: params)
        AppDelegate.current().requestSender!.sendRequest(apiRequest: request, completion: { (result) in
            self.hideProgress()
            switch result {
            case .success( _):
                self.wizardController()?.showNext()
                self.didUpdateProfile()
            case .failure( _): break
            }
        })
    }

    
    func isHeaderButtonEnabled(index: Int) -> Bool {
        if (index == RegisterViewController.Pages.credentials.rawValue) {
            return false
        }
        
        return validator.validate() == .valid
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return textField != dateOfBirthTextField
    }
    
}


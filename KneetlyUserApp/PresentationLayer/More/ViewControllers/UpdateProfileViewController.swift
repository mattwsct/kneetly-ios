//
//  UpdateProfileViewController.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott Dolzhikova on 07/02/2017.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import KneetlyCommon
import UIKit

class UpdateProfileViewController: RegisterProfileViewController {
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func fillUserInfo() {
        self.firstNameTextField.text = user.firstName ?? ""
        self.lastNameTextField.text = user.lastName ?? ""
        if let dob = user.dob {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let date = formatter.date(from: dob)
            self.dateOfBirth = date
            formatter.dateFormat = "dd/MM/yyyy"
            self.dateOfBirthTextField.text = formatter.string(from: date!)
        }
        self.streetAddressTextField.text = user.streetaddress ?? ""
        self.suburbTextField.text = user.suburb ?? ""
        self.stateTextField.text = user.state ?? ""
        self.countryTextField.text = user.country ?? ""
        self.postcodeTextField.text = user.postcode ?? ""
        self.mobilePhone.text = user.phone ?? ""
        self.genderPicker.gender = (user.gender == 0) ? .male : .female

    }
    
    @IBAction func saveButtonDidPressed(sender: UIButton) {
        switch validator.validate() {
        case .valid:
            self.updateProfile()
            break
        case .invalid:
            validator.displayValidationStatus()
            break
        }
    }
}

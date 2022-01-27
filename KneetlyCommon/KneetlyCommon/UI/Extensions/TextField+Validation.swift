//
//  FormTextField.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 02.12.16.
//  Copyright © 2016 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import KneetlyCommon
import Validator

extension UITextField: ValidatableControl {
    
    public var validatingValue: String {
        return self.text ?? ""
    }
    
    public func displayValidationResult(result: ValidationResult) {
        switch result {
        case .valid:
            displayNormalState()
        case .invalid:
            displayInvalidState()
        }
    }
    
    public func validatableValueDidChanged(value: String) {
        displayNormalState()
    }
    
    private func displayNormalState() {
        self.textColor = R.color.kneetly.textDarkBlue()
        self.placeholderColor = R.color.kneetly.textPaleGray()
    }
    
    private func displayInvalidState() {
        self.textColor = R.color.kneetly.orangeyRed()
        self.placeholderColor = R.color.kneetly.orangeyRed()
        self.shake()
    }
}

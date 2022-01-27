//
//  GenderPickerValidation.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 29.12.16.
//  Copyright © 2016 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import KneetlyCommon
import Validator

extension GenderPicker.Gender: Validatable {}

extension GenderPicker: ValidatableControl {
    
    public var validatingValue: Gender {
        return self.gender
    }
    
    public func displayValidationResult(result: ValidationResult) {
        switch result {
        case .invalid:
            self.shake()
            
        default:
            break
        }
    }
}

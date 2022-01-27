//
//  Validatable.swift
//  KneetlyUsers
//
//  Created by Matt Westcott on 29.11.16.
//  Copyright © 2016 Be IT Safe Pty Ltd. All rights reserved.
//

import UIKit
import Validator

public protocol ValidatableControl {
    
    associatedtype ValidatingType: Validatable
    
    var control: UIControl { get }
    var validatingValue: ValidatingType { get }
    
    func displayValidationResult(result: ValidationResult)
    func validatableValueDidChanged(value: ValidatingType)
}

public extension ValidatableControl {
    
    func displayValidationResult(result: ValidationResult) {
        
    }
    
    func validatableValueDidChanged(value: ValidatingType) {
        
    }
}



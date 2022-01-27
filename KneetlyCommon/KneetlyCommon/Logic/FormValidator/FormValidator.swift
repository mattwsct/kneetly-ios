//
//  FormValidator.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 01.12.16.
//  Copyright © 2016 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import Validator

public class FormValidator: Validator {
    
    private var controlValidators = Set<AnyControlValidator>()
    
    public init() {
    
    }
    
    public func setRules<Control>(ruleSet: ValidationRuleSet<Control.ValidatingType>, forControl control: Control)
        where Control:ValidatableControl, Control.ValidatingType: Validatable
    {
        let validator = ControlValidator(control: control, rules: ruleSet)
        controlValidators.insert(AnyControlValidator(validator: validator))
    }
    
    public func validate() -> ValidationResult {
        let results = controlValidators.map { $0.validate() }
        return ValidationResult.merge(results: results)
    }
    
    public func displayValidationStatus() {
        controlValidators.forEach { $0.displayValidationStatus() }
    }
}

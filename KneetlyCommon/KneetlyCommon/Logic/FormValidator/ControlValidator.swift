//
//  ControlValidator.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 02.12.16.
//  Copyright © 2016 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import Validator

protocol AbstractControlValidator: Validator {
    var control: UIControl { get }
    
    func displayValidationStatus()
}

final class AnyControlValidator: AbstractControlValidator, Hashable {
    let validator: AbstractControlValidator
    
    init<C: AbstractControlValidator>(validator: C) {
        self.validator = validator
    }
    
    var control: UIControl {
        return validator.control
    }
    
    func validate() -> ValidationResult {
        return validator.validate()
    }
    
    func displayValidationStatus() {
        validator.displayValidationStatus()
    }
    
    var hashValue: Int {
        return control.hashValue
    }
    
    static func ==(lhs: AnyControlValidator, rhs: AnyControlValidator) -> Bool {
        return lhs.control.isEqual(rhs.control)
    }
}

final class ControlValidator<Control: ValidatableControl>: AbstractControlValidator
    where Control.ValidatingType: Validatable
{
    typealias RuleSet = ValidationRuleSet<Control.ValidatingType>
    
    private let validatableControl: Control
    private let rules: RuleSet
    
    init(control: Control, rules: RuleSet) {
        self.validatableControl = control
        self.rules = rules
        
        control.control.addTarget(self, action: #selector(onValueDidChange), for: .editingChanged)
    }
    
    var control: UIControl {
        return validatableControl.control
    }
    
    func validate() -> ValidationResult {
        return validatableControl.validatingValue.validate(rules: rules)
    }
    
    func displayValidationStatus() {
        validatableControl.displayValidationResult(result: validate())
    }
    
    @objc private func onValueDidChange() {
        validatableControl.validatableValueDidChanged(value: validatableControl.validatingValue)
    }
}

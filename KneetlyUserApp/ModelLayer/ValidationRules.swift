//
//  ValidationRules.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 05.12.16.
//  Copyright © 2016 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import Validator
import PhoneNumberKit
import KneetlyCommon

// Validator for date strings with format dd/mm/yyyy
private struct ValidationRuleDate: ValidationRule {
    
    private let validRange: ClosedRange<Date>?
    private static let dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    init(inRange: ClosedRange<Date>? = nil) {
        self.validRange = inRange
    }
    
    func validate(input: String?) -> Bool {
        guard let input = input else { return false }
        
        guard let date = ValidationRuleDate.dateFormatter.date(from: input) else { return false }
        
        if let validRange = validRange {
            guard validRange.contains(date) else { return false }
        }
        
        return true
    }
    
    var error: Error {
        return UserError.wrongInput(description: "Wrong birthday format")
    }
}

private struct ValidationRulePhoneNumber: ValidationRule {
    func validate(input: String?) -> Bool {
        guard let input = input else { return false }
        
        let phoneKit = PhoneNumberKit()
        
        do {
            _ = try phoneKit.parse(input)
        } catch {
            return false
        }
        
        return true
    }
    
    var error: Error {
        return UserError.wrongInput(description: "Invalid phone number")
    }
}

enum ValidationRules {
    private static let nonEmptyRule = ValidationRuleLength(min: 1, error: UserError.wrongInput(description: "Too short"))
    private static let emailRule = ValidationRulePattern(pattern: EmailValidationPattern.standard, error: UserError.wrongInput(description: "Wrong email format"))
    private static let birthdayFormat = ValidationRuleDate()
    private static let phoneNumberFormat = ValidationRulePhoneNumber()
    private static let gender = ValidationRuleContains(sequence: [GenderPicker.Gender.male, GenderPicker.Gender.female], error: UserError.wrongInput(description: "Gender is not selected"))
    
    static let email = ValidationRuleSet(rules: [emailRule])
    static let nonEmpty = ValidationRuleSet(rules: [nonEmptyRule])
    static let birthday = ValidationRuleSet(rules: [birthdayFormat])
    static let phoneNumber = ValidationRuleSet(rules: [phoneNumberFormat])
    static let validGender = ValidationRuleSet(rules: [gender])
}

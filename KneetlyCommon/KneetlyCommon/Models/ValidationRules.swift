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
        
        if input.characters.count < ValidationRuleDate.dateFormatter.dateFormat.characters.count {
            return false
        }
        
        guard let date = ValidationRuleDate.dateFormatter.date(from: input) else { return false }
        
        if date.year > Date().year {
            return false
        }
        
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

private struct ValidationRuleYear: ValidationRule {
    
    private static let dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()
    
    func validate(input: String?) -> Bool {
        guard let input = input else { return false }
        
        if input.characters.count < ValidationRuleYear.dateFormatter.dateFormat.characters.count  {
            return false
        }
        
        guard let date = ValidationRuleYear.dateFormatter.date(from: input) else { return false }
        
        if date.year > Date().year {
            return false
        }
        
        return true
    }
    
    var error: Error {
        return UserError.wrongInput(description: "Invalid year")
    }
}

public enum ValidationRules {
    private static let nonEmptyRule = ValidationRuleLength(min: 1, error: UserError.wrongInput(description: "Too short"))
    private static let emailRule = ValidationRulePattern(pattern: EmailValidationPattern.standard, error: UserError.wrongInput(description: "Wrong email format"))
    private static let birthdayFormat = ValidationRuleDate()
    private static let phoneNumberFormat = ValidationRulePhoneNumber()
    private static let gender = ValidationRuleContains(sequence: [GenderPicker.Gender.male, GenderPicker.Gender.female], error: UserError.wrongInput(description: "Gender is not selected"))
    private static let yearFormat = ValidationRuleYear()
    private static let bankAccountNumberRule = ValidationRulePattern(pattern: "[0-9]+", error: UserError.wrongInput(description: "Not a bank account number"))
    private static let bsbRule = ValidationRulePattern(pattern: "[0-9]{6}", error: UserError.wrongInput(description: "Not a bsb"))
    
    public static let email = ValidationRuleSet(rules: [emailRule])
    public static let nonEmpty = ValidationRuleSet(rules: [nonEmptyRule])
    public static let birthday = ValidationRuleSet(rules: [birthdayFormat])
    public static let phoneNumber = ValidationRuleSet(rules: [phoneNumberFormat])
    public static let validGender = ValidationRuleSet(rules: [gender])
    public static let year = ValidationRuleSet(rules: [yearFormat])
    public static let bankAccountNumber = ValidationRuleSet(rules: [bankAccountNumberRule])
    public static let bsb = ValidationRuleSet(rules: [bsbRule])
}

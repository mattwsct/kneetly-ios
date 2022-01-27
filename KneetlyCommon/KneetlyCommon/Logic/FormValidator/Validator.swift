//
//  ControllValidator.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 01.12.16.
//  Copyright © 2016 Be It Safe Pty Ltd. All rights reserved.
//

import Validator

protocol Validator {
    func validate() -> ValidationResult
}

//
//  Errors.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 05.12.16.
//  Copyright © 2016 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation

public enum UserError: Error {
    case wrongInput(description: String)
}

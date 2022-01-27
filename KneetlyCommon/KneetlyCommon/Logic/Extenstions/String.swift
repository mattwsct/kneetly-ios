//
//  String.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 10.02.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import ObjectMapper

extension String {
    
    public var intValue: Int? {
        let converter = NumberFormatter()
        converter.locale = Locale.current
        return converter.number(from: self)?.intValue
    }
    
    public static let intTransform = TransformOf<Int, String>(
        fromJSON: { (value: String?) -> Int? in
            var intValue: Int?
            if let value = value {
                intValue = value.intValue
            }
            return intValue
        },
        toJSON: { (value: Int?) -> String? in
            var stringValue: String?
            if let value = value {
                stringValue = "\(value)"
            }
            return stringValue
        }
    )
}

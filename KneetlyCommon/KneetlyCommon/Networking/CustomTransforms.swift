//
//  Transforms.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 27.01.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import ObjectMapper

struct CustomTransform {
    
    static let StringToDouble = TransformOf<Double, String>(
        fromJSON: { (value: String?) -> Double? in
            var intValue: Double?
            if let value = value {
                let converter = NumberFormatter()
                converter.locale = NSLocale.current
                if let number = converter.number(from: value) {
                    intValue = number.doubleValue
                }
            }
            return intValue
        },
        toJSON: { (value: Double?) -> String? in
            var stringValue: String?
            if let value = value {
                stringValue = "\(value)"
            }
            return stringValue
        }
    )
    
    static let StringToInt = TransformOf<Int, String>(
        fromJSON: { (value: String?) -> Int? in
            var intValue: Int?
            if let value = value {
                let converter = NumberFormatter()
                converter.locale = NSLocale.current
                if let number = converter.number(from: value) {
                    intValue = number.intValue
                }
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
    
    static let StringToBool = TransformOf<Bool, String>(
        fromJSON: { (value: String?) -> Bool? in
            var boolValue: Bool?
            if let value = value {
                let converter = NumberFormatter()
                converter.locale = NSLocale.current
                if let number = converter.number(from: value) {
                    boolValue = number.boolValue
                }
            }
            return boolValue
        },
        toJSON: { (value: Bool?) -> String? in
            var stringValue: String?
            if let boolValue = value, Int(boolValue as NSNumber) != nil {
                stringValue = "\((boolValue as NSNumber).intValue)"
            }
            return stringValue
        }
    )
}

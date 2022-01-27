//
//  Date.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 20.01.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftDate

public enum DefaultServerDateFormat: String {
    case
    long = "YYYY-MM-dd hh:mm:ss",
    short = "YYYY-MM-dd"
    
    public func transform() -> TransformOf<Date, String> {
        return TransformOf<Date, String>(
            fromJSON: { (value: String?) -> Date? in
                return Date.dateFromServer(string: value ?? "", format: self)
            },
            toJSON: { (value: Date?) -> String? in
                return value?.string(custom: self.rawValue)
            }
        )
    }
}

extension Date {
    
    static func date(string: String, format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: string)
    }
    
    static func dateFromServer(string: String, format: DefaultServerDateFormat) -> Date? {
        return date(string: string, format: format.rawValue)
    }
    
    public func colloquialRepresentation() -> String {
        var result = ""
        do {
            let colloquial = try self.colloquialSinceNow()
            result = colloquial.colloquial
        } catch let error as NSError {
            print ("Date formatting error: %@", error)
        }
        return result
    }
}

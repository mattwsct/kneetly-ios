//
//  BookingResult.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 01/02/2017.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import ObjectMapper
import KneetlyCommon

class BookingResult: ApiObject {
    
    private enum Keys: String {
        case bookingId = "Booking Id"
    }
    
    public private (set) var bookingId: String!
    
    override func mapObject(map: Map) {
        super.mapObject(map: map)
        bookingId <- map[Keys.bookingId.rawValue]
    }
    
    override func requiredKeys() -> [String] {
        return [Keys.bookingId.rawValue]
    }
}

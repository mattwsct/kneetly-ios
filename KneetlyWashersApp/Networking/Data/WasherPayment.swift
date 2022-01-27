//
//  WasherPayment.swift
//  KneetlyWashersApp
//
//  Created by Matt Westcott on 21.02.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import KneetlyCommon
import ObjectMapper

class WasherPayment: ApiObject {

    private enum Keys: String {
        case id = "id", accountId = "account_id", accountNumber = "account_number", amount = "amount", paymentDate = "payment_date", bookingId = "booking_id", washerId = "washer_id"
    }
    
    var id: String!
    var accountId: String!
    var accountNumber: String!
    var amount: Int = 0
    var paymentDate: Date!
    var bookingId: String?
    var washerId: String?
    
    override func mapObject(map: Map) {
        super.mapObject(map: map)
        id <- map[Keys.id.rawValue]
        accountId <- map[Keys.accountId.rawValue]
        accountNumber <- map[Keys.accountNumber.rawValue]
        amount <- map[Keys.amount.rawValue]
        paymentDate <- (map[Keys.paymentDate.rawValue], DateTransform())
        bookingId <- map[Keys.bookingId.rawValue]
        washerId <- map[Keys.washerId.rawValue]
    }
    
    override open func requiredKeys() -> [String] {
        return [Keys.id.rawValue, Keys.accountId.rawValue, Keys.accountNumber.rawValue, Keys.amount.rawValue, Keys.paymentDate.rawValue]
    }
}

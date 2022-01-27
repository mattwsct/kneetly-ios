//
//  BankAccountInfo.swift
//  KneetlyWashersApp
//
//  Created by Matt Westcott on 09.02.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import KneetlyCommon
import ObjectMapper

class BankAccountInfo: ApiObject {

    private enum Keys: String {
        case accountName = "accountname", accountNumber = "accountnumber", bsb = "bsb", bank = "bank"
    }
    
    var accountName: String = ""
    var accountNumber: String = ""
    var bsb: String = ""
    var bank: String = ""
    
    override func mapObject(map: Map) {
        super.mapObject(map: map)
        accountName <- map[Keys.accountName.rawValue]
        accountNumber <- map[Keys.accountNumber.rawValue]
        bsb <- map[Keys.bsb.rawValue]
        bank <- map[Keys.bank.rawValue]
    }
    
    override open func requiredKeys() -> [String] {
        return []
    }
}

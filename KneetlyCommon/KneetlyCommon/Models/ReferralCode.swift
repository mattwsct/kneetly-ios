//
//  ReferralLink.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 14.02.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import ObjectMapper

public class ReferralCode: ApiObject {

    private enum Keys: String {
        case referralCode = "referral_code"
    }
    
    public var referralCode: String!
    
    public override func mapObject(map: Map) {
        super.mapObject(map: map)
        referralCode <- map[Keys.referralCode.rawValue]
    }
    
    public override func requiredKeys() -> [String] {
        return [Keys.referralCode.rawValue]
    }
}

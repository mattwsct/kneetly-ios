//
//  Business.swift
//  KneetlyCommon
//
//  Created by Matt Westcott Dolzhikova on 07/02/2017.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import ObjectMapper

public class Business: ApiObject {
    
    private enum Keys: String {
        case id = "id", name = "name", abn = "abn", streetaddress = "streetaddress", suburb = "suburb", state = "state", country = "country", postcode = "postcode", type = "type", email = "email", address = "address"
    }
    
    public var id: String!
    public var name: String!
    public var abn: String!
    public var address: String!
    public var streetaddress: String!
    public var suburb: String!
    public var state : String!
    public var country : String!
    public var postcode : String!
    public var type : Int!
    public var email: String!
    
    public override func mapObject(map: Map) {
        super.mapObject(map: map)
        id <- map[Keys.id.rawValue]
        name <- map[Keys.name.rawValue]
        abn <- map[Keys.abn.rawValue]
        streetaddress <- map[Keys.streetaddress.rawValue]
        suburb <- map[Keys.suburb.rawValue]
        state <- map[Keys.state.rawValue]
        country <- map[Keys.country.rawValue]
        postcode <- map[Keys.postcode.rawValue]
        type <- map[Keys.type.rawValue]
        email <- map[Keys.email.rawValue]
        address <- map[Keys.address.rawValue]
    }
    
    public override func requiredKeys() -> [String] {
        return [Keys.id.rawValue, Keys.name.rawValue, Keys.abn.rawValue, Keys.streetaddress.rawValue, Keys.suburb.rawValue, Keys.state.rawValue, Keys.country.rawValue, Keys.postcode.rawValue, Keys.address.rawValue]
    }
}

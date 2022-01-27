//
//  WashType.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 1/13/17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import ObjectMapper

public class WashType: ApiObject {

    private enum Keys: String {
        case id = "id", name = "name", vehicleType = "vehicle_type", price = "price", description = "description"
    }
    
    public var id: Int!
    public var name: String!
    public var vehicleType: String!
    public var price: Double!
    public var description: String!
    
    public override func mapObject(map: Map) {
        super.mapObject(map: map)
        id <- map[Keys.id.rawValue]
        name <- map[Keys.name.rawValue]
        description <- map[Keys.description.rawValue]
        price <- map[Keys.price.rawValue]
        vehicleType <- map[Keys.vehicleType.rawValue]
    }
    
    public override func requiredKeys() -> [String] {
        return [Keys.id.rawValue, Keys.description.rawValue, Keys.vehicleType.rawValue, Keys.price.rawValue, Keys.name.rawValue]
    }
}

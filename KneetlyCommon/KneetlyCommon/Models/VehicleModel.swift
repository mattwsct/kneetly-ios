//
//  VehicleModel.swift
//  KneetlyCommon
//
//  Created by Matt Westcott Dolzhikova on 18/01/2017.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import ObjectMapper

public class VehicleModel: ApiObject {
    private enum Keys: String {
        case id = "id", name = "name", type = "type"
    }
    
    public var name : String!
    var type : Int!
    public var id: String!
    
    override public func mapObject(map: Map) {
        super.mapObject(map: map)
        id <- map[Keys.id.rawValue]
        name <- map[Keys.name.rawValue]
        type <- map[Keys.type.rawValue]
    }
    
    override public func requiredKeys() -> [String] {
        return [Keys.id.rawValue, Keys.name.rawValue, Keys.type.rawValue]
    }
    
    public func vehicleType() -> CarType {
        switch type {
        case 1:
            return .small
        case 2:
            return .medium
        case 3:
            return .large
        default:
            return .small
        }
    }
}

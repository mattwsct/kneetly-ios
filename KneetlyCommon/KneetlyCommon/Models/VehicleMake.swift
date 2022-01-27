//
//  VehicleMake.swift
//  KneetlyCommon
//
//  Created by Matt Westcott Dolzhikova on 18/01/2017.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import ObjectMapper

public class VehicleMake: ApiObject {
    
    private enum Keys: String {
        case id = "id", name = "name"
    }
    
    public var name : String!
    public var id: String!
    
    override public func mapObject(map: Map) {
        super.mapObject(map: map)
        id <- map[Keys.id.rawValue]
        name <- map[Keys.name.rawValue]
    }
    
    override public func requiredKeys() -> [String] {
        return [Keys.id.rawValue, Keys.name.rawValue]
    }
}


//
//  CancellationCategory.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 02/02/2017.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import ObjectMapper

public class CancellationCategory: ApiObject {
    
    private enum Keys: String {
        case id = "id", name = "name", type = "type"
    }
    
    public var id: String = ""
    public var name: String = ""
    public var type: String = ""
    
    override public func mapObject(map: Map) {
        super.mapObject(map: map)
        id <- map[Keys.id.rawValue]
        name <- map[Keys.name.rawValue]
        type <- map[Keys.type.rawValue]
    }
    
    override public func requiredKeys() -> [String] {
        return [Keys.id.rawValue, Keys.name.rawValue, Keys.type.rawValue]
    }
}

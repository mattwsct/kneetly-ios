//
//  ProblemCategory.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 24.01.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import ObjectMapper

public class ProblemCategory: ApiObject {

    private enum Keys: String {
        case id = "id", name = "name", type = "type"
    }
    
    var id: String = ""
    var name: String = ""
    var type: String = ""
    
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

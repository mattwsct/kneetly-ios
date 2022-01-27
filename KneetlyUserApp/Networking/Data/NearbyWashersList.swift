//
//  NearbyWashersList.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 19/01/2017.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import KneetlyCommon
import ObjectMapper

class NearbyWashersList: ApiObject {
    
    private enum Keys: String {
        case radius = "radius", washers = "Washers"
    }
    
    var radius: Double!
    var washers: [WasherUser]!
    
    override func mapObject(map: Map) {
        super.mapObject(map: map)
        radius <- map[Keys.radius.rawValue]
        washers <- map[Keys.washers.rawValue]
    }
    
    override func requiredKeys() -> [String] {
        return [Keys.radius.rawValue, Keys.washers.rawValue]
    }
}

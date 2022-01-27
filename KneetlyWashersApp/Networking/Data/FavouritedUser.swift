//
//  FavouritedUser.swift
//  KneetlyWashersApp
//
//  Created by Matt Westcott on 08.02.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import KneetlyCommon
import ObjectMapper

class FavouritedUser: User {

    private enum Keys: String {
        case favouritedAt = "favourited_at", washesCount = "washcount"
    }
    
    var favouritedAt: Date?
    var washesCount: Int = 0
    
    override func mapObject(map: Map) {
        super.mapObject(map: map)
        favouritedAt <- (map[Keys.favouritedAt.rawValue], DateTransform())
        washesCount <- map[Keys.washesCount.rawValue]
    }
    
    override open func requiredKeys() -> [String] {
        return [Keys.favouritedAt.rawValue, Keys.washesCount.rawValue]
    }
}

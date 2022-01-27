//
//  Washer.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 24.01.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import ObjectMapper

public class WasherUser: User {
    
    private enum Keys: String {
        case lastOnline = "last_online", isWasherOnline = "washer_is_online", location = "location"
    }
    
    public var lastOnline: Date?
    public var isWasherOnline: Bool = false
    public var location: Location?
    
    override public func mapObject(map: Map) {
        super.mapObject(map: map)
        lastOnline <- (map[Keys.lastOnline.rawValue], DefaultServerDateFormat.long.transform())
        isWasherOnline <- map[Keys.isWasherOnline.rawValue]
        location <- map[Keys.location.rawValue]
    }
    
    override public func requiredKeys() -> [String] {
        return [Keys.lastOnline.rawValue, Keys.isWasherOnline.rawValue]
    }
}

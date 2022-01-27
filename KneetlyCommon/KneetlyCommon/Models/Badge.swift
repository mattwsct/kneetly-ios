//
//  Badge.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 30.01.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import ObjectMapper

public class Badge: ApiObject {
    
    private enum Keys: String {
        case id = "id", name = "name", description = "description", imageURL = "iconurl", isAchieved = "got"
    }
    
    public var id: String = ""
    public var name: String = ""
    public var description: String = ""
    public var imageURL: String = ""
    public var isAchieved: Bool = false
    
    override public func mapObject(map: Map) {
        super.mapObject(map: map)
        id <- map[Keys.id.rawValue]
        name <- map[Keys.name.rawValue]
        description <- map[Keys.description.rawValue]
        imageURL <- map[Keys.imageURL.rawValue]
        isAchieved <- map[Keys.isAchieved.rawValue]
    }
    
    override public func requiredKeys() -> [String] {
        return [Keys.id.rawValue, Keys.name.rawValue, Keys.description.rawValue, Keys.imageURL.rawValue, Keys.isAchieved.rawValue]
    }
}

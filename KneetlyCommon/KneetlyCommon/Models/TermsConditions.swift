//
//  TermsConditions.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 26.01.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import ObjectMapper

public class TermsConditions: ApiObject {

    private enum Keys: String {
        case id = "id", title = "title", description = "htmldescription"
    }
    
    public var id: String = ""
    public var title: String = ""
    public var description: String = ""
    
    public var expanded: Bool = false
    
    override public func mapObject(map: Map) {
        super.mapObject(map: map)
        id <- map[Keys.id.rawValue]
        title <- map[Keys.title.rawValue]
        description <- map[Keys.description.rawValue]
    }
    
    override public func requiredKeys() -> [String] {
        return [Keys.id.rawValue, Keys.title.rawValue, Keys.description.rawValue]
    }
}

//
//  VideoItem.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 1/26/17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import ObjectMapper

open class VideoItem: ApiObject {
    
    private enum Keys: String {
        case  id = "id", title = "title", duration = "duration", url = "url", isWatched = "is_watched"
    }
    
    public private(set) var id: String!
    public private(set) var title: String?
    public private(set) var duration: Int = 0
    public private(set) var url: String!
    public var isWatched: Bool?
    
    override open func mapObject(map: Map) {
        super.mapObject(map: map)
        
        id <- map[Keys.id.rawValue]
        title <- map[Keys.title.rawValue]
        duration <- map[Keys.duration.rawValue]
        url <- map[Keys.url.rawValue]
        isWatched <- map[Keys.isWatched.rawValue]
    }
    
    override open func requiredKeys() -> [String] {
        return [Keys.id.rawValue, Keys.url.rawValue]
    }
}
 

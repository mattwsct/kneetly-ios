//
//  LoginResult.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 12/21/16.
//  Copyright © 2016 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import ObjectMapper

open class LoginResult: ApiObject {
    
    private enum Keys: String {
        case token = "access_token", redirections = "redirections"
    }
    
    public private (set) var token: String!
    public private (set) var lastAppState: LastAppState?
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        token <- map[Keys.token.rawValue]
        lastAppState <- map[Keys.redirections.rawValue]
    }
    
    override open func requiredKeys() -> [String] {
        return [Keys.token.rawValue]
    }
}

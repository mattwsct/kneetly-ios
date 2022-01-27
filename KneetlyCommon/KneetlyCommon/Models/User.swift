//
//  User.swift
//  KneetlyCommon
//
//  Created by Matt Westcott Dolzhikova on 18/01/2017.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import ObjectMapper

open class User: ApiObject {
    
    public enum UserGender {
        case male
        case female
    }
    
    private enum Keys: String {
        case id = "id", email = "email", firstName = "firstname", lastName = "lastname", dob = "dob", phone = "phone", streetaddress = "streetaddress", suburb = "suburb", state = "state", country = "country", postcode = "postcode", loginId = "login_id", gender = "gender", rating = "rating", avatar = "avatar"
    }
    
    public var id: String!
    public var email : String!
    public var firstName : String?
    public var lastName : String?
    public var dob : String?
    public var phone : String?
    public var streetaddress : String?
    public var suburb : String?
    public var state : String?
    public var country : String?
    public var postcode : String?
    public var loginId : String?
    public var gender : Int = 0
    public var rating: Double = 0
    public var avatar: String = ""
    
    override open func mapObject(map: Map) {
        super.mapObject(map: map)
        id <- map[Keys.id.rawValue]
        email <- map[Keys.email.rawValue]
        firstName <- map[Keys.firstName.rawValue]
        lastName <- map[Keys.lastName.rawValue]
        dob <- map[Keys.dob.rawValue]
        phone <- map[Keys.phone.rawValue]
        streetaddress <- map[Keys.streetaddress.rawValue]
        suburb <- map[Keys.suburb.rawValue]
        state <- map[Keys.state.rawValue]
        country <- map[Keys.country.rawValue]
        postcode <- map[Keys.postcode.rawValue]
        loginId <- map[Keys.loginId.rawValue]
        gender <- map[Keys.gender.rawValue]
        rating <- map[Keys.rating.rawValue]
        avatar <- map[Keys.avatar.rawValue]
    }
    
    override open func requiredKeys() -> [String] {
        return [Keys.id.rawValue, Keys.loginId.rawValue]
    }
    
    public func userGender() -> UserGender {
        switch gender {
        case 0:
            return .male
        case 1:
            return .female
        default:
            return .male
        }
    }
    
    static let mapper = Mapper<User>()
    
    open func dictionaryRepresentation() -> [String : Any] {
        return User.mapper.toJSON(self)
    }
    
    open func copy() -> User? {
        return User.mapper.map(JSON: self.dictionaryRepresentation())
    }
}

//
//  Vehicle.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 06/12/2016.
//  Copyright © 2016 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import ObjectMapper

public enum CarType : Int {
    case small = 1
    case medium
    case large
    
    public static let allValues = [small, medium, large]
    
    public var image: UIImage? {
        switch self {
        case .small:
            return R.image.carSmall()
        case .medium:
            return R.image.carMedium()
        case .large:
            return R.image.carLarge()
        }
    }
}

public class Vehicle: ApiObject {
    
    private enum Keys: String {
        case id = "id", businessId = "business_id", userId = "user_id", vehiclemodelId = "vehiclemodel_id", vehicleyear = "vehicleyear", registration = "registration", nickname = "nickname", makeModel = "vehicle_model", makeName = "vehicle_make", lastWash = "last_wash", type = "vehicle_type"
    }
    
    public var type : Int!
    public var id: String!
    public var businessId: String?
    public var userId: String?
    public var vehiclemodelId: String!
    public var vehicleyear: Int?
    public var registration: String!
    public var nickname: String!
    public var makeName: String!
    public var modelName: String!
    public var lastWash: Int?
    
    override public func mapObject(map: Map) {
        super.mapObject(map: map)
        id <- map[Keys.id.rawValue]
        businessId <- map[Keys.businessId.rawValue]
        userId <- map[Keys.userId.rawValue]
        vehiclemodelId <- map[Keys.vehiclemodelId.rawValue]
        vehicleyear <- map[Keys.vehicleyear.rawValue]
        registration <- map[Keys.registration.rawValue]
        nickname <- map[Keys.nickname.rawValue]
        makeName <- map[Keys.makeName.rawValue]
        modelName <- map[Keys.makeModel.rawValue]
        lastWash <- map[Keys.lastWash.rawValue]
        type <- map[Keys.type.rawValue]
    }
    
    override public func requiredKeys() -> [String] {
        return [Keys.id.rawValue, Keys.type.rawValue, Keys.makeModel.rawValue, Keys.businessId.rawValue, Keys.makeModel.rawValue, Keys.vehiclemodelId.rawValue, Keys.nickname.rawValue]
    }
    
    public func vehicleType() -> CarType {
        
        switch type {
        case 1:
            return .small
        case 2:
            return .medium
        case 3:
            return .large
        default:
            return .small
        }
        
    }
}

//
//  Booking.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 31.01.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import ObjectMapper

public class BookingWash: ApiObject {
    
    private enum Keys: String {
        case id = "id", userId = "user_id", washerId = "washer_id", vehicleId = "vehicle_id", vehicleNickname = "vehicle_nickname", washtypeId = "washtype_id", status = "status", isWasherComing = "is_washer_come_to_me", price = "price", longitude = "longitude", latitude = "latitude", startTime = "starttime", endTime = "endtime", scheduledTime = "scheduledtime", arrivedTime = "arrivedtime", washerLongitude = "washerlongitude", washerLatitude = "washerlatitude", userLongitude = "userlongitude", userLatitude = "userlatitude", damageAcceptance = "damageacceptance", direction = "direction", stripeId = "stripe_id", businessId = "business_id", makeModel = "vehicle_model_name", makeName = "vehicle_manufacture_name", washTypeName = "wash_type_name", vehicleType = "vehicle_type", userFirstName = "user_first_name", washTypeDescription = "washtype_description", vehicleRegistration = "vehicle_registration", address = "address", bookingStatus = "redirection_code"
    }
    
    public var id: String!
    public var userId: String!
    public var washerId: String!
    public var vehicleId: String!
    public var vehicleNickname: String!
    public var washtypeId: Int!
    public var status: Int?
    public var isWasherComing: Bool!
    public var price: Double?
    public var longitude: Double?
    public var latitude: Double?
    public var startTime: Date?
    public var endTime: Date?
    public var scheduledTime: Date?
    public var arrivedTime: Date?
    public var washerLongitude: Double = 0
    public var washerLatitude: Double = 0
    public var userLongitude: Double = 0
    public var userLatitude: Double = 0
    public var damageAcceptance: String?
    public var direction: String?
    public var stripeId: String?
    public var businessId: String?
    public var makeName: String!
    public var modelName: String!
    public var washTypeName: String?
    public var vehicleType: CarType!
    public var userFirstName: String = ""
    public var washTypeDescription: String?
    public var vehicleRegistration: String!
    public var address: String?
    public var bookingStatus: AppUserStatus!
    
    override public func mapObject(map: Map) {
        super.mapObject(map: map)
        id <- map[Keys.id.rawValue]
        userId <- map[Keys.userId.rawValue]
        washerId <- map[Keys.washerId.rawValue]
        vehicleId <- map[Keys.vehicleId.rawValue]
        vehicleNickname <- map[Keys.vehicleNickname.rawValue]
        washtypeId <- (map[Keys.washtypeId.rawValue], String.intTransform)
        status <- map[Keys.status.rawValue]
        isWasherComing <- map[Keys.isWasherComing.rawValue]
        price <- map[Keys.price.rawValue]
        longitude <- map[Keys.longitude.rawValue]
        latitude <- map[Keys.latitude.rawValue]
        startTime <- (map[Keys.startTime.rawValue], DateTransform())
        endTime <- (map[Keys.endTime.rawValue], DateTransform())
        scheduledTime <- (map[Keys.scheduledTime.rawValue], DateTransform())
        arrivedTime <- (map[Keys.arrivedTime.rawValue], DateTransform())
        washerLongitude <- map[Keys.washerLongitude.rawValue]
        washerLatitude <- map[Keys.washerLatitude.rawValue]
        userLongitude <- map[Keys.userLongitude.rawValue]
        userLatitude <- map[Keys.userLatitude.rawValue]
        damageAcceptance <- map[Keys.damageAcceptance.rawValue]
        direction <- map[Keys.direction.rawValue]
        stripeId <- map[Keys.stripeId.rawValue]
        businessId <- map[Keys.businessId.rawValue]
        makeName <- map[Keys.makeName.rawValue]
        modelName <- map[Keys.makeModel.rawValue]
        washTypeName <- map[Keys.washTypeName.rawValue]
        vehicleType <- (map[Keys.vehicleType.rawValue], EnumTransform<CarType>())
        userFirstName <- map[Keys.userFirstName.rawValue]
        washTypeDescription <- map[Keys.washTypeDescription.rawValue]
        vehicleRegistration <- map[Keys.vehicleRegistration.rawValue]
        address <- map[Keys.address.rawValue]
        bookingStatus <- map[Keys.bookingStatus.rawValue]
        if bookingStatus == nil {
            bookingStatus = .unknown
        }

    }
    
    override public func requiredKeys() -> [String] {
        return [Keys.id.rawValue, Keys.userId.rawValue, Keys.washerId.rawValue, Keys.vehicleId.rawValue, Keys.vehicleNickname.rawValue, Keys.washtypeId.rawValue, Keys.isWasherComing.rawValue, Keys.makeName.rawValue, Keys.makeModel.rawValue, Keys.vehicleType.rawValue, Keys.vehicleRegistration.rawValue]
    }
}

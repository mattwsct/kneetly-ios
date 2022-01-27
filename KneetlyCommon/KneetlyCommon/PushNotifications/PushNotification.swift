//
//  PushNotificationManager.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 1/31/17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import ObjectMapper

public typealias NotificationInfo = [AnyHashable: Any]

public protocol PushNotificationType {
    
}

public struct PushNotification<T: PushNotificationType> {
    public let isReceivedInBackground: Bool
    public let type: T
}

public enum WashflowStatus: Int {
    case jobFound = 1
    case washerFound = 2
    case washerIsUnavailable = 3
    case washerHasNotResponded = 4
    case noWasherFound = 6
    case userAcceptsJob = 7
    case scheduledWashReminderForUser = 8
    case scheduledWashReminderForWasher = 9
    case washerCancelledBooking = 10
    case washerArrived = 11
    case washerAddedDamage = 12
    case userConfirmedDamage = 13
    case washStarted = 14
    case washCompleted = 15
    case userCancelledWash = 16
}

public enum BadgesType {
    
}

public enum PaymentStatus: Int {
    case paymentDeclined = 1
}

public enum PushNotificationCategory: Int, Mappable {
    case washflow = 0, badges = 1, payment = 4, none = -1
    
    public init?(map: Map) {
        self = .washflow
    }
    
    mutating public func mapping(map: Map) {
        let source = map.JSON["type"] as! String
        var val = Int(source)
        self = PushNotificationCategory(rawValue: val!) ?? .none
    }
}

public class WashflowInfoMessage: ApiObject {
    
    private enum Keys: String {
        case status = "status", washerId = "washer_id", bookingId = "booking_id", userId = "user_id", vehicleId = "vehicle_id"
    }
    
    public var status: WashflowStatus!
    public var washerId: String!
    public var bookingId: String!
    public var userId: String!
    public var vehicleId: String?
    
    override public func mapObject(map: Map) {
        super.mapObject(map: map)
        status <- map[Keys.status.rawValue]
        washerId <- map[Keys.washerId.rawValue]
        bookingId <- map[Keys.bookingId.rawValue]
        vehicleId <- map[Keys.vehicleId.rawValue]
        userId <- map[Keys.userId.rawValue]
    }
    
    public convenience init?(forBooking booking: BookingWash) {
        self.init()
        
        if let bookingStatus = booking.status {
            status = WashflowStatus(rawValue: bookingStatus)
        }
        washerId = booking.washerId
        bookingId = booking.id
        vehicleId = booking.vehicleId
        userId = booking.userId
    }
}

public class BadgeInfoMessage: ApiObject {
    
    private enum Keys: String {
        case type = "status", message = "message", imageUrl = "image_url"
    }
    
    public var type: BadgesType!
    public var message: String!
    public var imageUrl: String!
    
    override public func mapObject(map: Map) {
        super.mapObject(map: map)
        type <- map[Keys.type.rawValue]
        message <- map[Keys.message.rawValue]
        imageUrl <- map[Keys.imageUrl.rawValue]
    }
}

public class PaymentInfoMessage: ApiObject {
    private enum Keys: String {
        case status = "status", washerId = "washer_id", bookingId = "booking_id", userId = "user_id", vehicleId = "vehicle_id"
    }
    
    public var status: PaymentStatus!
    public var washerId: String!
    public var bookingId: String!
    public var userId: String!
    public var vehicleId: String?
    
    override public func mapObject(map: Map) {
        super.mapObject(map: map)
        status <- map[Keys.status.rawValue]
        washerId <- map[Keys.washerId.rawValue]
        bookingId <- map[Keys.bookingId.rawValue]
        vehicleId <- map[Keys.vehicleId.rawValue]
        userId <- map[Keys.userId.rawValue]
    }
}

extension PushNotificationParser {
    
    public static func parseWashflowNotification(data: [String: Any]) -> WashflowInfoMessage?  {
        guard let washStr = data["wash"] as? String, let washInfo = convertToDictionary(text: washStr), let info = WashflowInfoMessage(JSON: washInfo)  else {
            return nil
        }
        
        return info
    }
    
    public static func parseBadgeNotification(data: [String: Any]) -> BadgeInfoMessage? {
        guard let str = data["booking"] as? String, let bookingInfo = convertToDictionary(text: str), let info = BadgeInfoMessage(JSON: bookingInfo) else {
            return nil
        }
        
        return info
    }
    
    public static func parsePaymentNotification(data: [String: Any]) -> PaymentInfoMessage? {
        guard let paymentStr = data["payment"] as? String, let paymentInfo = convertToDictionary(text: paymentStr), let info = PaymentInfoMessage(JSON: paymentInfo)  else {
            return nil
        }
        
        return info
    }
    
    public static func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}


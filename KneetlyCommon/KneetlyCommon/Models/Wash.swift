//
//  Wash.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 20/12/2016.
//  Copyright © 2016 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation

public enum WashLocationType: Int, CustomStringConvertible {
    case comeToMe = 1
    case goToThem = 0
    
    public static let allValues = [comeToMe, goToThem]
    
    public static let allDescriptions = WashLocationType.allValues.map { $0.description }
    
    public var description: String {
        switch self {
        case .comeToMe:
            return R.string.localized.washLocationTypeComeToMe()
        case .goToThem:
            return R.string.localized.washLocationTypeGoToThem()
        }
    }
}

public class Wash {
    public var vehicleId: String?
    public var vehicleNickname: String?
    public var vehicleType: CarType?
    public var washTypeId: Int?
    public var washTypeName: String?
    public var scheduledTime: Date?
    public var locationType: WashLocationType = .comeToMe
    public var washerId: String?
    public var isWasherOnline: Bool = false
    
    public init() {}
}

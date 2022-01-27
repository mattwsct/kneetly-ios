//
//  Damage.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 15/12/2016.
//  Copyright © 2016 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

public enum DamageType {
    case interior
    case exterior
}

public class DamagePoint {
    public var xPosition: CGFloat!
    public var yPosition: CGFloat!
    public var pointView: UIView!
    
    public init(x: CGFloat, y: CGFloat, point: UIView) {
        self.xPosition = x;
        self.yPosition = y;
        self.pointView = point;
    }
}

public class Damage: ApiObject {
    private enum Keys: String {
        case id = "id", vehicleId = "vehicle_id", xcoordinate = "xcoordinate", ycoordinate = "ycoordinate", description = "description", type = "type", imageUrl = "image_url"
    }
    
    public var id: String!
    public var vehicleId: String!
    public var xcoordinate: Double!
    public var ycoordinate: Double!
    public var description: String?
    public var imageUrl: String = ""
    var type: Int!
    
    public var damagePoint: DamagePoint?
    
    override public func mapObject(map: Map) {
        super.mapObject(map: map)
        id <- map[Keys.id.rawValue]
        vehicleId <- map[Keys.vehicleId.rawValue]
        xcoordinate <- map[Keys.xcoordinate.rawValue]
        ycoordinate <- map[Keys.ycoordinate.rawValue]
        description <- map[Keys.description.rawValue]
        type <- map[Keys.type.rawValue]
        imageUrl <- map[Keys.imageUrl.rawValue]
    }
    
    override public func requiredKeys() -> [String] {
        return [Keys.id.rawValue, Keys.vehicleId.rawValue, Keys.xcoordinate.rawValue, Keys.ycoordinate.rawValue, Keys.type.rawValue]
    }
    
    public func damageType() -> DamageType {
        return (type == 1) ? .interior : .exterior
    }
}

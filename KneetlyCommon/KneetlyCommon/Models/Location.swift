//
//  Location.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 01.02.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import CoreLocation
import ObjectMapper

public class Location: ApiObject {
    
    public var latitude: Double = 0
    public var longitude: Double = 0
    
    private enum Keys: String {
        case latitude = "latitude", longitude = "longitude"
    }
    
    override public func mapObject(map: Map) {
        super.mapObject(map: map)
        latitude <- map[Keys.latitude.rawValue]
        longitude <- map[Keys.longitude.rawValue]
    }
    override public func requiredKeys() -> [String] {
        return [Keys.latitude.rawValue, Keys.longitude.rawValue]
    }
}

public class AddressedLocation {
    public var coordinate: CLLocationCoordinate2D
    public var address: String?
    
    public init(coordinate: CLLocationCoordinate2D, address: String? = nil) {
        self.coordinate = coordinate
        self.address = address
    }
}

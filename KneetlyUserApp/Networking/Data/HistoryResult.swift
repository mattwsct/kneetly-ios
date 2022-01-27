//
//  HistoryResult.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 06.02.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import ObjectMapper
import KneetlyCommon

public class HistoryResult: ApiObject {

    private enum Keys: String {
        case scheduled = "scheduled", completed = "washed"
    }
    
    public private (set) var scheduled: [BookingWash] = []
    public private (set) var completed: [BookingWash] = []
    
    public override func mapObject(map: Map) {
        super.mapObject(map: map)
        scheduled <- map[Keys.scheduled.rawValue]
        completed <- map[Keys.completed.rawValue]
    }
    
    public override func requiredKeys() -> [String] {
        return [Keys.scheduled.rawValue, Keys.completed.rawValue]
    }
}

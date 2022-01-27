//
//  Collection.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 09/12/2016.
//  Copyright © 2016 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation

public extension Array {
    public func randomElement() -> Iterator.Element {
        return self[Int(arc4random_uniform(UInt32(self.count)))]
    }
}

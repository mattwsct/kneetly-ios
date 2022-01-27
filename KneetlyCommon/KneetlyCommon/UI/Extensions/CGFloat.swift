//
//  CGFloat.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 07/12/2016.
//  Copyright © 2016 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation

extension CGFloat
{
    public static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    public static func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        if min < max {
            return CGFloat.random() * (min - max) + max
        }
        return CGFloat.random() * (max - min) + min
    }
    
    public func degreesToRadians() -> CGFloat {
        return CGFloat(M_PI) * self / 180.0
    }
    
    public func radiansToDegrees() -> CGFloat {
        return self * 180.0 / CGFloat(M_PI)
    }
}

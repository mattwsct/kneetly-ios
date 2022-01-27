//
//  Theme.swift
//  KneetlyUsers
//
//  Created by Matt Westcott on 28.11.16.
//  Copyright © 2016 Be IT Safe Pty Ltd. All rights reserved.
//

import UIKit

extension UIFont {
    enum kneetly {
        static func titleFont() -> UIFont {
            return R.font.gibsonRegular(size: 20)!
        }
        
        static func headerFont() -> UIFont {
            return R.font.gibsonRegular(size: 12)!
        }
        
        static func bigButtonFont() -> UIFont {
            return R.font.gibsonLight(size: 24)!
        }
        
        static func buttonFontOfSize(_ size: CGFloat) -> UIFont {
            return R.font.gibsonLight(size: size)!
        }
    }
}

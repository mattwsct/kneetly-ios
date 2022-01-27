//
//  Collection+SafeSubscript.swift
//  KneetlyUsers
//
//  Created by Matt Westcott on 25.11.16.
//  Copyright © 2016 Be IT Safe Pty Ltd. All rights reserved.
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {
    
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

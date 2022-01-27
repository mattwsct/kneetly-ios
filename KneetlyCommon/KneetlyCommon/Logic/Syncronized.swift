//
//  Syncronized.swift
//  KneetlyUsers
//
//  Created by Matt Westcott on 24.11.16.
//  Copyright © 2016 Be IT Safe Pty Ltd. All rights reserved.
//

import Foundation

func syncronized(_ lock:Any, block:(Void) -> Void) {
    objc_sync_enter(lock)
    block()
    objc_sync_exit(lock)
}

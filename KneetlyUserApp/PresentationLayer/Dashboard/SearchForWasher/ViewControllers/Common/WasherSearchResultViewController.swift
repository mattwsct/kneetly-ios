//
//  WasherSearchResultViewController.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 14/02/2017.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit

class WasherSearchResultViewController: UIViewController, WashCancellation {
    
    var bookingId: String!

    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        cancelWash(forBookingId: bookingId)
    }
}

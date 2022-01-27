//
//  WasherLocationSelectionViewController.swift
//  KneetlyWashersApp
//
//  Created by Matt Westcott on 03/02/2017.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import CoreLocation
import KneetlyCommon

class WasherLocationSelectionViewController: LocationSelectionViewController {
    
    override var location: AddressedLocation? {
        didSet {
            if let location = location {
                delegate?.didSelectLocation(location)
                updatePins(animated: true)
            }
        }
    }
}


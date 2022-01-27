//
//  UserLocationSelectionViewController.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 01/02/2017.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import MapKit
import KneetlyCommon

class UserLocationSelectionViewController: LocationSelectionViewController {

    override var location: AddressedLocation? {
        didSet {
            updatePins(animated: true)
            
            guard let location = location else {
                return
            }
            
            if location.address == nil {
                MapsService.shared.reverseGeocode(coordinate: location.coordinate) { [unowned self] (address: String?) in
                    
                    location.address = address ?? ""
                    self.delegate?.didSelectLocation(location)
                    self.updateLocationInfo(withAddress: location.address)
                }
            }
            else {
                delegate?.didSelectLocation(location)
                updateLocationInfo(withAddress: location.address)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = R.string.localized.confirmBookingWhereIsYourCarWaitingForWashFormat(dataSource?.carName() ?? R.string.localized.confirmBookingDefaultCarName())
        
        if dataSource?.isWasherComing() == true {
            subtitleLabel.text = R.string.localized.confirmBookingCarLocationLabelText()
        }
        else {
            subtitleLabel.text = R.string.localized.confirmBookingWeAllocateAWasherNearbyLabelText()
        }
    }
    
}

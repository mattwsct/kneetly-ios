//
//  OrderConfirmationViewController.swift
//  KneetlyWashersApp
//
//  Created by Matt Westcott on 01/02/2017.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import CoreLocation
import KneetlyCommon

class OrderConfirmationViewController: SetWasherLocationViewController {
    
    override func request(withLocation location: AddressedLocation) -> ApiRequest<ApiObject, ApiErrorCategory<ApiDefaultError>>? {
        return ApiEndpoints.LookingForJob.mobileWashOnlyRequest(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
    
    override func goNext() {
        performSegue(withIdentifier: R.segue.orderConfirmationViewController.lookingForUser.identifier, sender: self)
    }
}

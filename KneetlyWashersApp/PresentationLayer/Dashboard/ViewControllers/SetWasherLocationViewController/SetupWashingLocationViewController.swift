//
//  SetupWashingLocationViewController.swift
//  KneetlyWashersApp
//
//  Created by Matt Westcott on 03/02/2017.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import CoreLocation
import KneetlyCommon

class SetupWashingLocationViewController: SetWasherLocationViewController {

    @IBOutlet weak var acceptMobileSwitch: UISwitch!
    
    override func request(withLocation location: AddressedLocation) -> ApiRequest<ApiObject, ApiErrorCategory<ApiDefaultError>>? {
        return ApiEndpoints.LookingForJob.setWashLocationRequest(location: location, acceptMobile: acceptMobileSwitch.isOn)
    }
    
    override func goNext() {
        performSegue(withIdentifier: R.segue.setupWashingLocationViewController.toLookingForUser, sender: self)
    }
}

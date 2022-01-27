//
//  AddVehicleViewController.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott Dolzhikova on 19/01/2017.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import KneetlyCommon

class AddVehicleViewController: RegisterVehicleViewController {
    
    @IBAction func addVehicle(sender: UIButton) {
        switch self.validator.validate() {
        case .valid:
            self.addVehicle(parameters: self.getParameters())
        case .invalid:
            validator.displayValidationStatus()
        }
    }
}

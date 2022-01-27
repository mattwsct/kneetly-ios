//
//  UpdateVehicleViewController.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 24/01/2017.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import KneetlyCommon

class UpdateVehicleViewController: RegisterVehicleViewController {
    
    public var didUpdateVehicle : ()->() = { _ in }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateVehicleInfo()
    }

    @IBAction func saveVehicle(sender: UIButton) {
        switch self.validator.validate() {
        case .valid:
            self.updateVehicle()
            break
        case .invalid:
            validator.displayValidationStatus()
            break
        }
    }
    
    func updateVehicleInfo() {
        guard let currentVehicle = self.vehicle else {
            return
        }
        
        self.carRegistration.text = currentVehicle.registration ?? ""
        self.carNickname.text = currentVehicle.nickname ?? ""
        if let year = currentVehicle.vehicleyear {
            self.carYear.text = "\(year)"
        }
    }
    
    func updateVehicle() {
        guard let currentVehicle = self.vehicle else {
            return
        }
        
        showProgress()
        
        let request = ApiEndpoints.Vehicles.updateRequest(vehicleId: currentVehicle.id, parameters: self.getParameters())
        AppDelegate.current().requestSender!.sendRequest(apiRequest: request, completion: { (result) in
            self.hideProgress()
            switch result {
            case .success(_):
                self.didUpdateVehicle()
                break
            case .failure(let error):
                KneetlyAlert.show(errorMessage: error.message ?? "")
                break
            }
        })
    }
    
}

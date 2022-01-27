//
//  SetWasherLocationViewController.swift
//  KneetlyWashersApp
//
//  Created by Matt Westcott on 07/02/2017.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import CoreLocation
import KneetlyCommon

class SetWasherLocationViewController: UIViewController {

    var washerLocation: AddressedLocation?
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func goNext() {
    }
    
    func request(withLocation: AddressedLocation) -> ApiRequest<ApiObject, ApiErrorCategory<ApiDefaultError>>? {
        return nil
    }
    
    @IBAction func readyButtonTapped(_ sender: Any) {
        guard let washerLocation = washerLocation else {
            KneetlyAlert.show(errorMessage: R.string.localized.setLocationErrorShouldSelectLocation())
            return
        }
        
        if washerLocation.address == nil {
            showProgress()
            MapsService.shared.reverseGeocode(coordinate: washerLocation.coordinate) { [unowned self] (address: String?) in
                self.hideProgress()
                washerLocation.address = address ?? ""
                self.sendRequest()
            }
        }
        else {
            sendRequest()
        }
    }
    
    private func sendRequest() {
        guard let request = request(withLocation: washerLocation!) else {
            return
        }
        
        showProgress()
        AppDelegate.current().requestSender.sendRequest(apiRequest: request) { [unowned self] (result) in
            
            self.hideProgress()
            
            switch result {
            case .success( _):
                self.goNext()
            case .failure(let error):
                KneetlyAlert.show(errorMessage: error.message ?? "")
            }
        }
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let dst = segue.destination as? WasherLocationSelectionViewController {
            dst.delegate = self
        }
    }
}

extension SetWasherLocationViewController: LocationSelectionDelegate {
    public func didSelectLocation(_ location: AddressedLocation?) {
        washerLocation = location
    }
}

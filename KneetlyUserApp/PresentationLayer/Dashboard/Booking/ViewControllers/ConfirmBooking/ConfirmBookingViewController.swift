//
//  ConfirmBookingViewController.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 14/12/2016.
//  Copyright © 2016 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import CoreLocation
import KneetlyCommon

class ConfirmBookingViewController: ContainerViewController, WashCancellation {

    var vehicleId: String!
    
    var bookingId: String!
    
    fileprivate var booking: BookingWash?
    
    fileprivate var vehicle: Vehicle?
    
    fileprivate var washLocation: AddressedLocation?
    
    fileprivate var washerId: String?
    
    // MARK: Outlets
    
    @IBOutlet private weak var containerView: UIView!
    
    @IBOutlet private weak var paymentInfoContainerView: UIView!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    // MARK: ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func getData() {
        showProgress()
        
        let bookingRequest = ApiEndpoints.Booking.getBooking(id: bookingId)
        
        AppDelegate.current().requestSender.sendRequest(apiRequest: bookingRequest, completion: { [unowned self] (result) in
            self.hideProgress()
            switch result {
            case .success(let booking):
                self.booking = booking
                self.getVehicle()
            case .failure(let error):
                KneetlyAlert.show(errorMessage: error.message ?? "")
            }
        })
    }
    
    private func getVehicle() {
        showProgress()
        
        let vehicleRequest = ApiEndpoints.VehicleRequest.getVehicle(id: vehicleId)
        
        AppDelegate.current().requestSender.sendRequest(apiRequest: vehicleRequest, completion: { [unowned self] (result) in
            self.hideProgress()
            switch result {
            case .success(let vehicle):
                self.vehicle = vehicle
                self.configureUI()
            case .failure(let error):
                KneetlyAlert.show(errorMessage: error.message ?? "")
            }
        })
    }
    
    private func configureUI() {
        confirmButton.isHidden = false
        
        cancelButton.isHidden = false
        
        setupLocationSelectionMode()
        
        embedPaymentInfo()
    }
    
    // MARK: Actions
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        if Preferences.isLocationStoreAllowed() {
            confirmBooking()
        }
        else {
            let noButton = KneetlyAlertButton(title: R.string.localized.confirmBookingLocationStorageConfirmationNoButtonTitle(), titleColor: R.color.kneetly.orangeyRed(), handler: { [unowned self] in
                self.cancelWash(forBookingId: self.bookingId)
            })
            
            let okButton = KneetlyAlertButton(title: R.string.localized.confirmBookingLocationStorageConfirmationOkButtonTitle(), titleColor: R.color.kneetly.navyTone1(), borderColor: R.color.kneetly.green2(), handler: { [unowned self] in self.confirmBooking()
                Preferences.setLocationStoreAllowed(true)
            })
            
            KneetlyAlert.showWithButtons(title: R.string.localized.confirmBookingLocationStorageConfirmationText(), buttons: noButton, okButton)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        cancelWash(forBookingId: bookingId)
    }
    
    // MARK: Private
    
    private func isWasherLocationSelectionMode() -> Bool {
        return booking!.isWasherComing == false && booking!.scheduledTime == nil
    }
    
    private func embedPaymentInfo() {
        performSegue(withIdentifier: R.segue.confirmBookingViewController.embedPaymentInfo, sender: nil)
    }
    
    private func setupLocationSelectionMode() {
        if isWasherLocationSelectionMode() {
            switchToWasherLocationSelectionMode()
        }
        else {
            switchToUserLocationSelectionMode()
        }
    }
    
    private func confirmBooking() {
        guard let washLocation = washLocation else {
            KneetlyAlert.show(errorMessage: R.string.localized.confirmBookingErrorShouldSelectLocation())
            return
        }
        
        let request = ApiEndpoints.Booking.setLocationRequest(bookingId: bookingId, location: washLocation, washerId: washerId)
        
        showProgress()
        AppDelegate.current().requestSender.sendRequest(apiRequest: request) { [unowned self] (result) in
            
            self.hideProgress()
            
            switch result {
            case .success( _):
                self.performSegue(withIdentifier: R.segue.confirmBookingViewController.toSearchForWasher, sender: self)
            case .failure(let error):
                KneetlyAlert.show(errorMessage: error.message ?? "")
            }
        }
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let dst = segue.destination as? LocationSelectionViewController {
            dst.delegate = self
            dst.washerSelectionDelegate = self
            dst.dataSource = self
        }
        else if let dst = segue.destination as? SearchForWasherViewController {
            dst.bookingId = bookingId
        }
        else if let dst = segue.destination as? BookingPaymentViewController {
            dst.businessId = vehicle!.businessId
        }
    }
    
    // MARK: ContainerViewController
    
    private func switchToWasherLocationSelectionMode() {
        performSegue(withIdentifier: R.segue.confirmBookingViewController.toWasherLocationSelection, sender: nil)
    }
    
    private func switchToUserLocationSelectionMode() {
        performSegue(withIdentifier: R.segue.confirmBookingViewController.toUserLocationSelection, sender: nil)
    }
    
    override func containerViewForSwitchSegue(segue: SwitchSegue) -> UIView {
        if segue.identifier == R.segue.confirmBookingViewController.embedPaymentInfo.identifier {
            return paymentInfoContainerView
        }
        
        return containerView
    }
}

extension ConfirmBookingViewController: LocationSelectionDelegate {
    public func didSelectLocation(_ location: AddressedLocation?) {
        washLocation = location
    }
}

extension ConfirmBookingViewController: WasherSelectionDelegate {
    public func didSelectWasher(_ id: String?) {
        washerId = id
    }
}

extension ConfirmBookingViewController: WashLocationSelectionDataSource {
    func carName() -> String? {
        return vehicle!.nickname
    }
    
    func isWasherComing() -> Bool {
        return booking!.isWasherComing
    }
}

//
//  WashInProgressViewController.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 23/01/2017.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import KneetlyCommon

class WashInProgressViewController: CommonWashInProgressViewController {
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getBookingAndWasherInfo()
    }
    
    func updateInfo(booking: BookingWash, washer: WasherUser?) {
        washInfoLabel.text = R.string.localized.washInProgressWashInfoLabelText(booking.washTypeName ?? "",
            "\(washer?.firstName != nil ? washer!.firstName! + " " : "")\(washer?.lastName ?? "")")
        washDescriptionLabel.text = booking.washTypeDescription
    }
    
    func getBookingAndWasherInfo() {
        showProgress()
        AppDelegate.current().requestSender!.sendRequest(apiRequest: ApiEndpoints.Booking.getBooking(id: bookingId), completion: { (result) in
            switch result {
            case .success(let booking):
                self.getWasher(washerId: booking.washerId) { washer in
                    self.updateInfo(booking: booking, washer: washer)
                }
            case .failure(let error):
                self.hideProgress()
                KneetlyAlert.show(errorMessage: error.message ?? "" )
            }
        })
    }
    
    private func getWasher(washerId: String, completion: @escaping (_ washer: WasherUser?) -> Void) {
        AppDelegate.current().requestSender.sendRequest(apiRequest: ApiEndpoints.Washer.getWasher(id: washerId)) { result in
            self.hideProgress()
            switch result {
            case .success(let washer):
                completion(washer)
            case .failure(let error):
                KneetlyAlert.show(errorMessage: error.message ?? "")
                completion(nil)
            }
        }
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case R.segue.washInProgressViewController.toProblems.identifier:
            if let problemVC = segue.destination as? ProblemViewController {
                problemVC.sender = .user
                problemVC.bookingsId = self.bookingId
            }
        default: break
        }
    }
    
    // MARK: - Actions
    
    @IBAction func resolveProblem() {
        // TODO: Should send bookings ID 
        performSegue(withIdentifier: R.segue.washInProgressViewController.toProblems, sender: self)
    }

}

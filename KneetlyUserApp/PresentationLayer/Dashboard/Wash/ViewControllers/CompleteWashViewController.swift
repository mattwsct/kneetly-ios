//
//  CompleteWashViewController.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 20.01.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import KneetlyCommon

class CompleteWashViewController: UIViewController {
    
    var bookingId: String = ""
    var booking: BookingWash?
    var washer: WasherUser?
    
    @IBOutlet weak var washInfoLabel: UILabel!
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getBookingAndWasherInfo()
        
        NotificationCenter.default.post(name: .vehiclesWasUpdated, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case R.segue.completeWashViewController.toProblems.identifier:
            if let problemVC = segue.destination as? ProblemViewController {
                problemVC.sender = .user
                problemVC.bookingsId = self.bookingId
            }
        case R.segue.completeWashViewController.toReview.identifier:
            if let reviewWasherVC = segue.destination as? ReviewViewController {
                reviewWasherVC.sender = .user
                reviewWasherVC.bookingsId = bookingId
                reviewWasherVC.washerId = booking?.washerId ?? ""
            }
        default: break
        }
    }
    
    // MARK: - Actions
    
    @IBAction func reviewWasher() {
        performSegue(withIdentifier: R.segue.completeWashViewController.toReview, sender: self)
    }
    
    @IBAction func resolveProblem() {
        performSegue(withIdentifier: R.segue.completeWashViewController.toProblems, sender: self)
    }
    
    // MARK: - Helpers
    
    private func getBookingAndWasherInfo() {
        showProgress()
        AppDelegate.current().requestSender.sendRequest(apiRequest: ApiEndpoints.Booking.getBooking(id: bookingId)) { result in
            switch result {
            case .success(let booking):
                self.booking = booking
                self.getWasher(washerId: booking.washerId) {
                    self.washInfoLabel.text = R.string.localized.completeWashWashInfoLabelText(
                        self.booking?.washTypeName ?? "",
                        "\(self.washer?.firstName != nil ? self.washer!.firstName! + " " : "")\(self.washer?.lastName ?? "")"
                    )
                }
            case .failure(let error):
                KneetlyAlert.show(errorMessage: error.message ?? "")
            }
        }
    }
    
    private func getWasher(washerId: String, completion: @escaping () -> Void) {
        AppDelegate.current().requestSender.sendRequest(apiRequest: ApiEndpoints.Washer.getWasher(id: washerId)) { result in
            self.hideProgress()
            switch result {
            case .success(let washer):
                self.washer = washer
            case .failure(let error):
                KneetlyAlert.show(errorMessage: error.message ?? "")
            }
            completion()
        }
    }
}

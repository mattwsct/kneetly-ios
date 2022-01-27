//
//  WashInProgressViewController.swift
//  KneetlyWashersApp
//
//  Created by Matt Westcott on 20/02/2017.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import KneetlyCommon

class WashInProgressViewController: CommonWashInProgressViewController {
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getBookingInfo()
    }
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case R.segue.washInProgressViewController.toProblems.identifier:
            if let problemVC = segue.destination as? ProblemViewController {
                problemVC.sender = .washer
                problemVC.bookingsId = self.bookingId
            }
        case R.segue.washInProgressViewController.toReview.identifier:
            if let reviewUserVC = segue.destination as? ReviewViewController {
                reviewUserVC.sender = .washer
                reviewUserVC.bookingsId = bookingId
            }
        default: break
        }
    }
    
    func updateInfo(booking: BookingWash) {
        let makeName = booking.makeName ?? ""
        let modelName = booking.modelName ?? ""
        
        washInfoLabel.text = R.string.localized.washInProgressWashInfoLabelText(booking.washTypeName ?? "", "\(makeName) \(modelName)")
        washDescriptionLabel.text = booking.washTypeDescription
    }
    
    func getBookingInfo() {
        showProgress()
        let request = ApiEndpoints.LookingForJob.getBookingWash(id: self.bookingId)
        AppDelegate.current().requestSender!.sendRequest(apiRequest: request, completion: { (result) in
            self.hideProgress()
            switch result {
            case .success(let booking):
                self.updateInfo(booking: booking)
                break
            case .failure(let error):
                KneetlyAlert.show(errorMessage: error.message ?? "" )
                break
            }
        })
    }
    
    // MARK: - Actions
    
    @IBAction func completeWash() {
        self.showProgress()
        let request = ApiEndpoints.WashProcess.finishRequest(bookingId:self.bookingId)
        AppDelegate.current().requestSender!.sendRequest(apiRequest: request, completion: { (result) in
            self.hideProgress()
            switch result {
            case .success(_):
                self.performSegue(withIdentifier: R.segue.washInProgressViewController.toReview.identifier, sender: self)
                break
            case .failure(let error):
                KneetlyAlert.show(errorMessage: error.message ?? "" )
                break
            }
        })
    }
    
}

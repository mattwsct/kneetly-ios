//
//  WasherIncomingViewController.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 31.01.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import KneetlyCommon

class WasherIncomingOrWaitingViewController: SomebodyIncomingOrWaitingViewController, WashCancellation {
    
    static func vc(withBookingId bookingId: String, washerId: String, userId: String) -> WasherIncomingOrWaitingViewController {
        let vc = R.storyboard.searchForWasher.washerIncomingOrWaitingViewController()!
        vc.configure(
            targetType: .user,
            bookingId: bookingId,
            targetId: washerId,
            bookingDataSource: DataSource<BookingWash>(
                requestSender: AppDelegate.current().requestSender,
                apiRequest: ApiEndpoints.Booking.getBooking(id: bookingId)
            ),
            targetDataSource: DataSource<User>(
                requestSender: AppDelegate.current().requestSender,
                apiRequest: ApiEndpoints.Washer.getWasherAsUser(id: washerId)
            ),
            targetLocationDataSource: DataSource<Location>(
                requestSender: AppDelegate.current().requestSender,
                apiRequest: ApiEndpoints.LocationRequest.getWasherLocationRequest(washerId: washerId)
            )
        )
        
        return vc
    }
    
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case R.segue.washerIncomingOrWaitingViewController.toPreWashChecklist.identifier:
            if let preWashChecklistVC = segue.destination as? PreWashChecklistViewController {
                preWashChecklistVC.configure(targetType: .user, bookingId: bookingId, state: .userSubmit)
            }
        default: break
        }
    }
    
    // MARK: - Actions
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        cancelWash(forBookingId: bookingId)
    }
}

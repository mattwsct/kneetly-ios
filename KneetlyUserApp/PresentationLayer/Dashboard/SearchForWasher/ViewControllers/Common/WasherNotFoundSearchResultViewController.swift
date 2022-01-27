//
//  WasherNotFoundSearchResultViewController.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 21.02.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import KneetlyCommon

class NoWasherSearchResultViewController: WasherSearchResultViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func chooseAnotherWasher() {
        showProgress()
        AppDelegate.current().requestSender.sendRequest(apiRequest: ApiEndpoints.Booking.getBooking(id: bookingId)) { result in
            self.hideProgress()
            switch result {
            case .success(let booking):
                let confirmBookingVC = R.storyboard.booking.confirmBookingViewController()!
                confirmBookingVC.bookingId = self.bookingId
                confirmBookingVC.vehicleId = booking.vehicleId
                if let tabbar = self.tabBarController as? TabBarController {
                    tabbar.show(vc: confirmBookingVC, tabIndex: .dashboard)
                }
            case .failure(let error):
                KneetlyAlert.show(errorMessage: error.message ?? "" )
            }
        }
    }
}

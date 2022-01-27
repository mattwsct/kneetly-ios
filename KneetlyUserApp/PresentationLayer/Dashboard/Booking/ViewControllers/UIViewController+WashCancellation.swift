//
//  UIViewController+WashCancellation.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 03/02/2017.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import KneetlyCommon

protocol WashCancellation {
    func cancelWash(forBookingId id: String)
}

extension WashCancellation where Self: UIViewController {
    func cancelWash(forBookingId id: String) {
        showProgress()
        
        AppDelegate.current().requestSender.sendRequest(
        apiRequest: ApiEndpoints.Booking.cancelRequest(bookingId: id)) { [unowned self] result in
            
            self.hideProgress()
            
            switch result {
            case .success(_):
                self.navigateToRootAnimated()
            case .failure(let error):
                KneetlyAlert.show(errorMessage: error.message ?? "")
            }
        }
    }
}

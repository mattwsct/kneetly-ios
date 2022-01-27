//
//  ScheduledBookingCell.swift
//  KneetlyWashersApp
//
//  Created by Matt Westcott on 17.02.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import KneetlyCommon
import SwiftDate

class ScheduledBookingCell: UITableViewCell {
    
    @IBOutlet weak var scheduledTimeLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    // MARK: - Initial configuration
    
    func configure(booking: BookingWash) {
        scheduledTimeLabel.text = getScheduledTime(date: booking.scheduledTime)
        detailsLabel.text = getDetails(booking: booking)
    }
    
    // MARK: - Helpers
    
    private func getScheduledTime(date: Date?) -> String {
        var result = " "
        if let date = date {
            do {
                let colloquial = try date.colloquialSinceNow()
                result = colloquial.colloquial
            } catch let error as NSError {
                print ("Date formatting error: %@", error)
            }
        }
        return result
    }
    
    private func getDetails(booking: BookingWash) -> String {
        var result = "\(booking.userFirstName)"
        if let date = booking.scheduledTime {
            result += " - \(date.string(custom: "ha")) - \(date.string(custom: "EEE dd MMM yyyy"))"
        }
        return result
    }
}

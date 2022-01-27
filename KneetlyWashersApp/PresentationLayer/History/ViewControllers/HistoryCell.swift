//
//  HistoryCell.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 06.02.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import KneetlyCommon
import SwiftDate

class HistoryCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var vehicleNameLabel: UILabel!
    @IBOutlet weak var washTypeLabel: UILabel!
    @IBOutlet weak var vehicleTypeImageView: UIImageView!
    
    // MARK: - Initial configuration
    
    func configure(booking: BookingWash) {
        timeLabel.text = getString(date: booking.endTime)
        vehicleNameLabel.text = booking.modelName ?? ""
        washTypeLabel.text = booking.washTypeName ?? ""
        vehicleTypeImageView.image = booking.vehicleType?.image
    }
    
    // MARK: - Helpers
    
    private func getString(date: Date?) -> String {
        var result = ""
        if let date = date {
            do {
                let colloquial = try date.colloquialSinceNow()
                result = colloquial.colloquial
                if let theExactTime = colloquial.time {
                    result += " \(theExactTime)"
                }
            } catch let error as NSError {
                print ("Date formatting error: %@", error)
            }
        }
        return result
    }
}

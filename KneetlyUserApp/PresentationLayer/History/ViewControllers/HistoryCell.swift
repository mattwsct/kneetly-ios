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
    @IBOutlet weak var rebookButton: KneetlyButton!
    
    var rebookAction: (() -> Void)?
    
    // MARK: - Initial configuration
    
    func configure(section: HistorySection, booking: BookingWash, rebookAction: (() -> Void)?) {
        var date: Date?
        switch section {
        case .scheduled:
            date = booking.scheduledTime
            rebookButton.isHidden = true
        case .completed:
            date = booking.endTime
        }
        timeLabel.text = getString(date: date)
        vehicleNameLabel.text = booking.modelName ?? ""
        washTypeLabel.text = "\(booking.washTypeName ?? "") ($\(booking.price ?? 0))"
        vehicleTypeImageView.image = booking.vehicleType?.image
        
        self.rebookAction = rebookAction
    }
    
    // MARK: - Actions
    
    @IBAction func rebook() {
        rebookAction?()
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

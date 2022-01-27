//
//  FavouriteCell.swift
//  KneetlyWashersApp
//
//  Created by Matt Westcott on 08.02.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import KneetlyCommon
import SwiftDate
import AlamofireImage

class FavouriteCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favouritedTimeLabel: UILabel!
    @IBOutlet weak var washesCountLabel: UILabel!
    
    // MARK: - Initial configuration
    
    func configure(user: FavouritedUser) {
        if let avatarURL = URL(string: user.avatar) {
            avatarImageView.af_setImage(withURL: avatarURL)
        }
        nameLabel.text = "\(user.firstName != nil ? user.firstName! + " " : "")\(user.lastName ?? "")"
        favouritedTimeLabel.text = getDateString(date: user.favouritedAt)
        washesCountLabel.text = R.string.localized.favouritedByWashesCountLabelText("\(user.washesCount)")
    }
    
    // MARK: - Helpers
    
    private func getDateString(date: Date?) -> String {
        var result = ""
        if let date = date {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .ordinal
            let dayOrdinalString = numberFormatter.string(from: (date.day as NSNumber)) ?? ""
            let dateString = date.string(custom: "MMMM, YYYY")
            result = R.string.localized.favouritedByFavouritedTimeLabelText("\(dayOrdinalString) \(dateString)")
        }
        return result
    }
}

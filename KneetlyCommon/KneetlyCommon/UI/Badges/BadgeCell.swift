//
//  BadgeCell.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 30.01.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import AlamofireImage

class BadgeCell: UITableViewCell {

    @IBOutlet weak var badgeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var notAchievedView: UIView!
    
    // MARK: - Initial configuration
    
    func configure(badge: Badge) {
        if let badgeImageURL = URL(string: badge.imageURL) {
            badgeImageView.af_setImage(withURL: badgeImageURL)
        }
        titleLabel.text = badge.name
        descriptionLabel.text = badge.description
        notAchievedView.isHidden = badge.isAchieved
    }
}

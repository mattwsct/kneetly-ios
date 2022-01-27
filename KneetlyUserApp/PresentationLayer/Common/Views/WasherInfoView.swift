//
//  WasherInfoView.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 03/02/2017.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import HCSStarRatingView
import KneetlyCommon

class WasherInfoView: UIView {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingView: HCSStarRatingView!
    
    func configure(withWasher washer: WasherUser?) {
        if let washer = washer {
            if let avatarURL = URL(string: washer.avatar) {
                avatarImageView.af_setImage(withURL: avatarURL)
            }
            nameLabel.text = "\(washer.firstName != nil ? washer.firstName! + " " : "")\(washer.lastName ?? "")"
            ratingView.value = CGFloat(washer.rating)
        }
    }

}

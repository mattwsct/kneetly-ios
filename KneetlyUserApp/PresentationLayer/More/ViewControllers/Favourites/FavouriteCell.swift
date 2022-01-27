//
//  FavouriteCell.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 19.01.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import KneetlyCommon
import SwiftDate
import AlamofireImage

class FavouriteCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var onlineStatusLabel: UILabel!
    
    var rebookAction: (() -> Void)?
    
    // MARK: - Initial configuration
    
    func configure(washer: WasherUser, rebookAction: (() -> Void)?) {
        if let avatarURL = URL(string: washer.avatar) {
            avatarImageView.af_setImage(withURL: avatarURL)
        }
        nameLabel.text = "\(washer.firstName != nil ? washer.firstName! + " " : "")\(washer.lastName ?? "")"
        do {
            if washer.isWasherOnline {
                onlineStatusLabel.text = R.string.localized.commonOnlineString()
            } else if let lastSeen = try washer.lastOnline?.colloquialSinceNow().colloquial {
                onlineStatusLabel.text = "\(R.string.localized.commonLastSeenString()) \(lastSeen)"
            } else {
                onlineStatusLabel.text = R.string.localized.commonOfflineString()
            }
        } catch let error as NSError {
            onlineStatusLabel.text = R.string.localized.commonOfflineString()
            print ("Date formatting error: %@", error)
        }
        
        self.rebookAction = rebookAction
    }
    
    // MARK: - Actions
    
    @IBAction func rebookWash() {
        rebookAction?()
    }
}

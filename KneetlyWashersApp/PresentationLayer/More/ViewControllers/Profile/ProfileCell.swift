//
//  ProfileCell.swift
//  KneetlyWashersApp
//
//  Created by Matt Westcott on 07.02.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import KneetlyCommon

class ProfileCell: UITableViewCell {

    @IBOutlet weak var profileTypeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!

    // MARK: - Intial configuration
    
    func configure(profile: User) {
        profileTypeLabel.text = R.string.localized.profileProfileTypeLabelText()
        nameLabel.text = "\(profile.firstName != nil ? profile.firstName! + " " : "")\(profile.lastName ?? "")"
    }
}

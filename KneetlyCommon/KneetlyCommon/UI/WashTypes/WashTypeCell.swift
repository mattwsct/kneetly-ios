//
//  WashTypeCell.swift
//  KneetlyWashersApp
//
//  Created by Matt Westcott on 31.01.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit

class WashTypeCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(washType: WashTypesViewController.WashType) {
        titleLabel.text = washType.title
    }
}

//
//  WashTypesDetailsViewController.swift
//  KneetlyWashersApp
//
//  Created by Matt Westcott on 31.01.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit

class WashTypeDetailsViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var smallCarPriceLabel: UILabel!
    @IBOutlet weak var mediumCarPriceLabel: UILabel!
    @IBOutlet weak var largeCarPriceLabel: UILabel!
    
    var type: WashTypesViewController.WashType!
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
    // MARK: - UI
    
    func updateUI() {
        titleLabel.text = type.title
        descriptionLabel.text = type.description
        smallCarPriceLabel.text = type.smallCarPrice
        mediumCarPriceLabel.text = type.mediumCarPrice
        largeCarPriceLabel.text = type.largeCarPrice
    }
}

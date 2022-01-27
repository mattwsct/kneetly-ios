//
//  BookingPaymentViewController.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 02/02/2017.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit

class BookingPaymentViewController: PaymentMethodViewController {
    @IBOutlet weak var cardInfoLabel: UILabel!
    
    @IBOutlet weak var cardImageView: UIImageView!

    @IBAction func changePaymentButtonTapped(_ sender: Any) {
        presentPaymentMethodsViewController(forBusinessId: businessId)
    }
    
    // MARK: PaymentMethodViewController
    
    override func didReceiveSelectedPaymentMethodName(_ name: String, image: UIImage, forBusinessId: String?) {
        guard businessId == forBusinessId else {
            return
        }
        
        cardInfoLabel.text = name
        cardImageView.image = image
    }
}

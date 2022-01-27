//
//  PaymentSectionFooterView.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 06/02/2017.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit

class PaymentSectionFooterView: UITableViewHeaderFooterView {
    
    static let height: CGFloat = 54.0
    
    var actionHandler: (() -> Void)?
    
    @IBAction func buttonTapped(_ sender: Any) {
        actionHandler?()
    }
}


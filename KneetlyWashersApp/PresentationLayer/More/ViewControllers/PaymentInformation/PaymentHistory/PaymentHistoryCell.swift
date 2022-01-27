//
//  PaymentHistoryCell.swift
//  KneetlyWashersApp
//
//  Created by Matt Westcott on 10.02.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import SwiftDate
import KneetlyCommon

class PaymentHistoryCell: UITableViewCell {
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - Initial configuration
    
    func configure(paymentHistory: WasherPayment) {
        amountLabel.text = "$\(paymentHistory.amount)"
        accountLabel.text = protectedAccountNumber(paymentHistory.accountNumber)
        dateLabel.text = paymentHistory.paymentDate.string(custom: "dd MMM YYYY")
    }
    
    // MARK: - Helpers
    
    func protectedAccountNumber(_ accountNumber: String) -> String {
        let visibleCharactersCount = 3
        var protected = ""
        for _ in 1...accountNumber.characters.count - visibleCharactersCount {
            protected += "*"
        }
        protected += String(accountNumber.characters.suffix(visibleCharactersCount))
        return protected
    }
}

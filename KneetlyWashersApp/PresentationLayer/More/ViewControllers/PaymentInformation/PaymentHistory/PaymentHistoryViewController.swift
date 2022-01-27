//
//  PaymentHistoryViewController.swift
//  KneetlyWashersApp
//
//  Created by Matt Westcott on 09.02.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import KneetlyCommon

class PaymentHistoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var paymentHistory: [WasherPayment] = []
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPaymentHistory()
    }
    
    // MARK: - Helpers
    
    private func getPaymentHistory() {
        showProgress(forView: view)
        AppDelegate.current().requestSender.sendRequest(apiRequest: ApiEndpoints.PaymentRequest.getPaymentHistory()) { result in
            self.hideProgress(forView: self.view)
            switch result {
            case .success(let paymentHistory):
                self.paymentHistory = paymentHistory
                self.tableView.reloadData()
            case .failure(let error):
                KneetlyAlert.show(errorMessage: error.message ?? "")
            }
        }
    }
}

extension PaymentHistoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.paymentHistoryCell)!
        cell.configure(paymentHistory: paymentHistory[indexPath.row])
        return cell
    }
}

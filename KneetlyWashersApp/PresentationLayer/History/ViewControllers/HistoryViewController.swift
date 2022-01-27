//
//  HistoryViewController.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 06.02.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import KneetlyCommon

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var completedBookings: [BookingWash] = []
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateHistory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Helpers
    
    private func updateHistory() {
        showProgress()
        let request = ApiEndpoints.HistoryRequest.getWashHistory()
        AppDelegate.current().requestSender!.sendRequest(
            apiRequest: request,
            completion: { result in
                self.hideProgress()
                switch result {
                case .success(let completedBookings):
                    self.completedBookings = completedBookings
                    self.tableView.reloadData()
                case .failure(let error):
                    KneetlyAlert.show(errorMessage: error.message ?? "")
                }
            }
        )
    }
}

extension HistoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completedBookings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.historyCell, for: indexPath)!
        cell.configure(booking: completedBookings[indexPath.row])
        return cell
    }
}

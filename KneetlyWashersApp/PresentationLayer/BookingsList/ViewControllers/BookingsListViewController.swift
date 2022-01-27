//
//  BookingsListViewController.swift
//  KneetlyWashersApp
//
//  Created by Matt Westcott on 17.02.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import KneetlyCommon

class BookingsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var scheduledBookings: [BookingWash] = []
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 60
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
        let request = ApiEndpoints.BookingsListRequest.getBookingsList()
        AppDelegate.current().requestSender!.sendRequest(
            apiRequest: request,
            completion: { result in
                self.hideProgress()
                switch result {
                case .success(let completedBookings):
                    self.scheduledBookings = completedBookings
                    self.tableView.reloadData()
                case .failure(let error):
                    KneetlyAlert.show(errorMessage: error.message ?? "")
                }
            }
        )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dst = segue.destination as? CancelledWashViewController, let targetBooking = sender as? BookingWash {
            dst.bookingId = targetBooking.id
            dst.didFinishHandler = { [unowned self] in
                _ = self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}

extension BookingsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduledBookings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.scheduledBookingCell, for: indexPath)!
        cell.configure(booking: scheduledBookings[indexPath.row])
        return cell
    }
}

extension BookingsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: R.segue.bookingsListViewController.toCancelWash, sender: scheduledBookings[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let state = LastAppState(forBooking: scheduledBookings[indexPath.row]), let request = ScreenNavigator.navigationRequest(basedOnLastAppState: state) {
            AppDelegate.current().handle(navigationRequest: request)
        }
    }
}

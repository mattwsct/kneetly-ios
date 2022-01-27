//
//  HistoryViewController.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 06.02.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import KneetlyCommon
import SnapKit

enum HistorySection: Int {
    case scheduled = 0, completed
    
    var title: String {
        get {
            var result = ""
            switch self {
            case .scheduled: result = R.string.localized.historyTableViewScheduledSectionTitle()
            case .completed: result = R.string.localized.historyTableViewCompletedSectionTitle()
            }
            return result
        }
    }
}

class HistoryViewController: UIViewController, WashCancellation {
    
    @IBOutlet weak var tableView: UITableView!
    
    var scheduledBookings: [BookingWash] = []
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
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let interviewVC = segue.destination as? InterviewViewController {
            let booking = sender as! BookingWash
            let wash = Wash()
            wash.vehicleId = booking.vehicleId
            wash.vehicleNickname = booking.vehicleNickname
            wash.vehicleType = booking.vehicleType
            
            interviewVC.planningWash = wash
        }
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
                case .success(let history):
                    self.scheduledBookings = history.scheduled
                    self.completedBookings = history.completed
                    self.tableView.reloadData()
                case .failure(let error):
                    KneetlyAlert.show(errorMessage: error.message ?? "")
                }
            }
        )
    }
    
    fileprivate func deleteBooking(id: String) {
        cancelWash(forBookingId: id)
    }
}

extension HistoryViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var result = 0
        if let section = HistorySection(rawValue: section) {
            switch section {
            case .scheduled: result = scheduledBookings.count
            case .completed: result = completedBookings.count
            }
        }
        return result
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.historyCell, for: indexPath)!
        var booking: BookingWash?
        if let section = HistorySection(rawValue: indexPath.section) {
            switch section {
            case .scheduled:
                booking = scheduledBookings[indexPath.row]
            case .completed:
                booking = completedBookings[indexPath.row]
            }
            cell.configure(section: section, booking: booking!) {
                self.performSegue(withIdentifier: R.segue.historyViewController.toInterview, sender: booking)
            }
        }
        return cell
    }
}

extension HistoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let headerHeight:CGFloat = 30
        var result:CGFloat = 0
        if let section = HistorySection(rawValue: section) {
            switch section {
            case .scheduled: if !scheduledBookings.isEmpty { result = headerHeight }
            case .completed: if !completedBookings.isEmpty { result = headerHeight }
            }
        }
        return result
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        let label = UILabel()
        label.font = R.font.gibsonRegular(size: 19)!
        label.textColor = R.color.kneetly.navyTone1()
        
        var result = ""
        if let section = HistorySection(rawValue: section) {
            switch section {
            case .scheduled: if !scheduledBookings.isEmpty { result = section.title }
            case .completed: if !completedBookings.isEmpty { result = section.title }
            }
        }
        label.text = result
        label.sizeToFit()
        
        headerView.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(18)
            make.top.equalToSuperview().offset(8)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if let section = HistorySection(rawValue: indexPath.section) {
            switch section {
            case .scheduled: return .delete
            case .completed: return .none
            }
        }
        
        return .none
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return R.string.localized.historyCancelActionTitle()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteBooking(id: scheduledBookings[indexPath.row].id)
            tableView.beginUpdates()
            scheduledBookings.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
}

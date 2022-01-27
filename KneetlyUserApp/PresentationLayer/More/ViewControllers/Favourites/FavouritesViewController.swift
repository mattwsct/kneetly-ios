//
//  FavouritesTableViewController.swift
//  KneetlyUsers
//
//  Created by Matt Westcott on 27/10/16.
//  Copyright © 2016 Be IT Safe Pty Ltd. All rights reserved.
//

import UIKit
import KneetlyCommon
import SwiftDate

class FavouritesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var washers: [WasherUser] = []
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableViewAutomaticDimension
        
        updateFavouritesList()
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let interviewVC = segue.destination as? InterviewViewController {
            if let washer = sender as? WasherUser {
                let wash = Wash()
                wash.washerId = washer.id
                wash.scheduledTime = washer.isWasherOnline ? nil : Date() + 30.minutes
                wash.isWasherOnline = washer.isWasherOnline
                
                interviewVC.planningWash = wash
            }
        }
    }
    
    // MARK: - Helpers
    
    private func updateFavouritesList() {
        showProgress()
        let favouritesList = ApiEndpoints.Favorite.listRequest()
        AppDelegate.current().requestSender!.sendRequest(
            apiRequest: favouritesList,
            completion: { result in
                self.hideProgress()
                switch result {
                case .success(let washers):
                    self.washers = washers
                    self.tableView.reloadData()
                case .failure(let error):
                    KneetlyAlert.show(errorMessage: error.message ?? "")
                }
            }
        )
    }
    
    fileprivate func deleteWasher(id: String) {
        let deleteFavoriteRequest = ApiEndpoints.Favorite.deleteRequest(washerId: id)
        AppDelegate.current().requestSender.sendRequest(
            apiRequest: deleteFavoriteRequest,
            completion: { result in
                switch result {
                case .success( _): break
                case .failure(let error):
                    KneetlyAlert.show(errorMessage: error.message ?? "")
                }
            }
        )
    }
}

extension FavouritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return washers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.favouriteCell, for: indexPath)!
        let washer = washers[indexPath.row]
        cell.configure(
            washer: washer,
            rebookAction: {
                self.performSegue(withIdentifier: R.segue.favouritesViewController.toInterview, sender: washer)
            }
        )
        return cell
    }
}

extension FavouritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteWasher(id: washers[indexPath.row].id)
            
            tableView.beginUpdates()
            washers.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
}

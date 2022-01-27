//
//  FavouritedByViewController.swift
//  KneetlyWashersApp
//
//  Created by Matt Westcott on 08.02.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import KneetlyCommon

class FavouritedByViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var favouritedBy: [FavouritedUser] = []
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableViewAutomaticDimension
        
        updateFavouritesList()
    }
    
    // MARK: - Helpers
    
    private func updateFavouritesList() {
        showProgress()
        let favouritesList = ApiEndpoints.FavouritesRequest.getFavourites()
        AppDelegate.current().requestSender!.sendRequest(
            apiRequest: favouritesList,
            completion: { result in
                self.hideProgress()
                switch result {
                case .success(let favouritedBy):
                    self.favouritedBy = favouritedBy
                    self.tableView.reloadData()
                case .failure(let error):
                    KneetlyAlert.show(errorMessage: error.message ?? "")
                }
            }
        )
    }
}

extension FavouritedByViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouritedBy.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.favouriteCell, for: indexPath)!
        cell.configure(user: favouritedBy[indexPath.row])
        return cell
    }
}

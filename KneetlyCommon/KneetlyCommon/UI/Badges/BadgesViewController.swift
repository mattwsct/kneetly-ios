//
//  BadgesViewController.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 30.01.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit

open class BadgesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    open var dataSource: DataSource<[Badge]>?
    
    fileprivate var badges: [Badge] {
        get {
            return dataSource?.items ?? []
        }
    }
    
    // MARK: - View controller lifecycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 73
        tableView.rowHeight = UITableViewAutomaticDimension
        
        reloadData()
    }
    
    // MARK: - Helpers
    
    private func reloadData() {
        showProgress()
        dataSource?.reload { [unowned self] in
            self.hideProgress()
            self.tableView?.reloadData()
        }
    }
}

extension BadgesViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return badges.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.badgeCell)!
        cell.configure(badge: badges[indexPath.row])
        return cell
    }
}

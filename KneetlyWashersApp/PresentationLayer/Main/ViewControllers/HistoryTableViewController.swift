//
//  HistoryTableViewController.swift
//  KneetlyWashers
//
//  Created by Matt Westcott on 10/10/16.
//  Copyright © 2016 Be IT Safe Pty Ltd. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var historyTitle: UILabel!
    @IBOutlet weak var historyDescription: UILabel!
    @IBOutlet weak var historyImage: UIImageView!
    
}

class HistoryTableViewController: UITableViewController {
    
    var titles = ["Thomas's Tesla", "Kassy's Corolla"]
    var subtitles = ["Washed yesterday", "Washed last week"]
    var images = ["carMedium", "carMedium"]
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryTableViewCell
        
        let title = titles[indexPath.row]
        let subtitle = subtitles[indexPath.row]
        let image = images[indexPath.row]
        cell.historyTitle.text = title
        cell.historyDescription.text = subtitle
        cell.historyImage.image = UIImage(named: image)
        
        return cell
    }

}

//
//  FavouritesTableViewController.swift
//  KneetlyWashers
//
//  Created by Matt Westcott on 10/10/16.
//  Copyright © 2016 Be IT Safe Pty Ltd. All rights reserved.
//

import UIKit

class FavouritesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var favouritesTitle: UILabel!
    @IBOutlet weak var favouritesDescription: UILabel!
    @IBOutlet weak var favouritesImage: UIImageView!
    
}

class FavouritesTableViewController: UITableViewController {
    
    var titles = ["Thomas", "Kassy"]
    var subtitles = ["Car wash reminder sent", "Tap to send wash reminder"]
    var images = ["profileMale", "profileFemale"]
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FavouritesTableViewCell
        
        let title = titles[indexPath.row]
        let subtitle = subtitles[indexPath.row]
        let image = images[indexPath.row]
        cell.favouritesTitle.text = title
        cell.favouritesDescription.text = subtitle
        cell.favouritesImage.image = UIImage(named: image)
        
        return cell
    }
}

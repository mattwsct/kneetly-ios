//
//  BookingsViewController.swift
//  KneetlyWashers
//
//  Created by Matt Westcott on 18/10/16.
//  Copyright © 2016 Be IT Safe Pty Ltd. All rights reserved.
//

import UIKit

class BookingsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bookingsTitle: UILabel!
    @IBOutlet weak var bookingsDescription: UILabel!
    @IBOutlet weak var bookingsImage: UIImageView!
}

class BookingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    var titles = ["In 1 hour", "In 2 days", "Next Week"]
    var subtitles = ["Henry - 2pm - Mon. 24 Oct. 2016", "Lucinda - 5pm - Wed. 26 Oct. 2016", "Sam - 12pm - Mon. 31 Oct. 2016"]
    var images = ["hoseHappy", "hoseToothy", "hoseSmiley"]
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! BookingsTableViewCell
        
        let title = titles[indexPath.row]
        let subtitle = subtitles[indexPath.row]
        let image = images[indexPath.row]
        cell.bookingsTitle.text = title
        cell.bookingsDescription.text = subtitle
        cell.bookingsImage.image = UIImage(named: image)
        
        return cell
    }
}

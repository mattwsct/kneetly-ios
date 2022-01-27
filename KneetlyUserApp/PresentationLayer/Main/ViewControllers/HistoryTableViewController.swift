//
//  Created by Matt Westcott.
//  Copyright © 2016 Be IT Safe Pty Ltd. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateTitle: UILabel!
    @IBOutlet weak var carTitle: UILabel!
    @IBOutlet weak var washTitle: UILabel!
    @IBOutlet weak var carImage: UIImageView!
}

class HistoryTableViewController: UITableViewController {

    var names = ["Miggles' Chariot", "Electric Dreams"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // Hides the top nav bar when this view loads
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    // Brings the nav bar back when exiting view
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    var cars = ["Toyota Corola", "Lamborghini Aventador", "Tesla Model S"]
    var washTypes = ["Basic Wash", "Deluxe Wash", "Deluxe Wash"]
    var dates = ["Yesterday", "Two days ago", "Last week"]
    var images = ["carSmall", "carMedium", "carMedium"]
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HistoryTableViewCell
        
        let car = cars[indexPath.row]
        let date = dates[indexPath.row]
        let washType = washTypes[indexPath.row]
        let image = images[indexPath.row]
        cell.dateTitle.text = date
        cell.washTitle.text = washType
        cell.carTitle.text = car
        cell.carImage.image = UIImage(named: image)
        
        return cell
    }

}

//
//  Created by Matt Westcott.
//  Copyright © 2016 Be IT Safe Pty Ltd. All rights reserved.
//

import UIKit
import KneetlyCommon

extension Notification.Name {
    static let vehiclesWasUpdated = Notification.Name("VehiclesWasUpdated")
}

class VehicleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var vehicleName: UILabel!
    @IBOutlet weak var vehicleType: UILabel!
    @IBOutlet weak var vehicleImage: UIImageView!
    
    func configure(vehicle: Vehicle) {
        
        let makeName = vehicle.makeName ?? ""
        let modelName = vehicle.modelName ?? ""
        
        self.vehicleName.text = vehicle.nickname ?? ""
        self.vehicleType.text =  "\(makeName) \(modelName)"
        self.vehicleImage.image = vehicle.vehicleType().image
    }
}

class VehiclesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var vehiclesDataSource: DataSource<[Vehicle]>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vehiclesDataSource = DataSource(requestSender: AppDelegate.current().requestSender, apiRequest: ApiEndpoints.Vehicles.vehicleListRequest())
        
        self.setupVehiclesDataSource()
        self.vehiclesDataSource.reload()
    }
    
    private func setupVehiclesDataSource() {
        vehiclesDataSource.onStateUpdated = { [weak self] dataSource, state in
            self?.handleDataLoading(withDataSource: dataSource, state: state, contentReloadHandler: { [weak self] in
               self?.tableView.reloadData()
                }, loadingStateHandler: { [weak self]  (loadingState) in
                    switch loadingState {
                    case .started:
                        self?.showProgress()
                        break
                    case .ended( _):
                        self?.hideProgress()
                        break
                    }
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.vehiclesViewController.toUpdateVehicle.identifier {
            let viewController =  segue.destination as! UpdateVehicleViewController
            if let indexPath = self.tableView.indexPathForSelectedRow {
                viewController.vehicle = self.vehiclesDataSource.items?[indexPath.row]
                
                viewController.didUpdateVehicle = {
                    let _ = self.navigationController?.popViewController(animated: true)
                    self.vehiclesDataSource.reload()
                    NotificationCenter.default.post(name: .vehiclesWasUpdated, object: nil)
                }
            }
        }
        
        if segue.identifier == R.segue.vehiclesViewController.toAddVehicle.identifier {
            let viewController =  segue.destination as! AddVehicleViewController
            
            viewController.didAddVehicle = {
                let _ = self.navigationController?.popViewController(animated: true)
                self.vehiclesDataSource.reload()
                NotificationCenter.default.post(name: .vehiclesWasUpdated, object: nil)
            }
        }
    }
}

extension VehiclesViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.vehiclesDataSource.items != nil) {
            return self.vehiclesDataSource.items!.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! VehicleTableViewCell
        
        if let vehicle = self.vehiclesDataSource.items?[indexPath.row] {
            cell.configure(vehicle: vehicle)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return (self.vehiclesDataSource.items!.count > 1)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            if let vehicle = self.vehiclesDataSource.items?[indexPath.row] {
                showProgress()
                let removeVehicleRequest = ApiEndpoints.Vehicles.removeRequest(vehicleId: vehicle.id)
                    AppDelegate.current().requestSender!.sendRequest(apiRequest: removeVehicleRequest, completion: { (result) in
                        self.hideProgress()
                        switch result {
                        case .success( _):
                            self.vehiclesDataSource.reload()
                            NotificationCenter.default.post(name: .vehiclesWasUpdated, object: nil)
                            break
                        case .failure(let error):
                            KneetlyAlert.show(errorMessage: error.message ?? "")
                            break
                        }
                    })
                }
        }
    }
}

//
//  Created by Matt Westcott.
//  Copyright © 2016 Be IT Safe Pty Ltd. All rights reserved.
//

import UIKit
import AKPickerView
import KneetlyCommon

class DashboardViewController: MascotAnimatedViewController {
    
    @IBOutlet weak var pickerView: AKPickerView!
    @IBOutlet weak var washStatus: UILabel!
    @IBOutlet weak var vehicleNickname: UILabel!
    @IBOutlet weak var vehicleType: UILabel!
    
    var vehiclesDataSource: DataSource<[Vehicle]>!
    
    var selectedVehicle: Vehicle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vehiclesDataSource = DataSource(requestSender: AppDelegate.current().requestSender, apiRequest: ApiEndpoints.Vehicles.vehicleListRequest())
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.pickerViewStyle = .styleFlat
        self.pickerView.interitemSpacing = 40.0
        self.setupVehiclesDataSource()
        self.reloadVehicles()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadVehicles), name: .vehiclesWasUpdated, object: nil)
    }
    
    private func setupVehiclesDataSource() {
        vehiclesDataSource.onStateUpdated = { [weak self] dataSource, state in
            self?.handleDataLoading(withDataSource: dataSource, state: state, contentReloadHandler: { [weak self] in
                self?.updateVehicles()
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
    
    func updateVehicles() {
        guard let car = self.vehiclesDataSource.items?[Int(self.pickerView.selectedItem)] else {
            return
        }
        self.selectedVehicle = car
        self.updateSelectedVehicle()
        
        self.pickerView.reloadData()
    }
    
    // Hides the top nav bar when this view loads
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        performMascotAnimation()
    }
    
    // Brings the nav bar back when exiting view
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    func reloadVehicles() {
        self.vehiclesDataSource.reload()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .vehiclesWasUpdated, object: nil);
    }
    
    func updateSelectedVehicle() {
        guard let vehicle = self.selectedVehicle else {
            return
        }
        
        let makeName = vehicle.makeName ?? ""
        let modelName = vehicle.modelName ?? ""
        
        let lastWash = vehicle.lastWash != nil ? Date(timeIntervalSince1970: Double(vehicle.lastWash!)).colloquialRepresentation() : R.string.localized.dashboardStatusLabelNeverWashedText()

        self.vehicleType.text =  "\(makeName) \(modelName)"
        self.vehicleNickname.text = vehicle.nickname
        self.washStatus.text = (lastWash.characters.count > 0) ? lastWash : R.string.localized.dashboardStatusLabelNeverWashedText()
    }
    
    // MARK: Actions
    
    @IBAction func bookButtonTapped(_ sender: Any) {
        guard let selectedVehicle = selectedVehicle else {
            return
        }
        
        performSegue(withIdentifier: R.segue.dashboardViewController.toInterview, sender: selectedVehicle)
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dst = segue.destination as? InterviewViewController {
            
            let vehicle = sender as! Vehicle
            let wash = Wash()
            wash.vehicleId = vehicle.id
            wash.vehicleNickname = vehicle.nickname
            wash.vehicleType = vehicle.vehicleType()
            
            dst.planningWash = wash
        }
    }
}

extension DashboardViewController: AKPickerViewDelegate, AKPickerViewDataSource {
    
    func numberOfItems(in pickerView: AKPickerView!) -> UInt {
        if (self.vehiclesDataSource.items != nil) {
            return UInt(self.vehiclesDataSource.items!.count)
        }
        return 0
    }
    
    public func pickerView(_ pickerView: AKPickerView, imageForItem item: Int) -> UIImage {
        if let vehicle = self.vehiclesDataSource.items?[item] {
                return (vehicle.vehicleType().image)!
            }
        return UIImage()
    }
    
    func pickerView(_ pickerView: AKPickerView!, didSelectItem item: Int) {
        if let vehicle = self.vehiclesDataSource.items?[item] {
            self.selectedVehicle = vehicle
            self.updateSelectedVehicle()
        }
        
        performMascotAnimation()
    }
}

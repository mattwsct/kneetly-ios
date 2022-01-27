//
//  Created by Suresh.
//  Copyright © 2016 Be IT Safe Pty Ltd. All rights reserved.
//

import UIKit
import KneetlyCommon
import AKPickerView
import Bond
import ActionSheetPicker_3_0
import ActiveLabel


class RegisterVehicleViewController: UIViewController,UITextFieldDelegate {
    
    private var vehicleMakeDataSource: DataSource<[VehicleMake]>?
    private var vehicleModelDataSource: DataSource<[VehicleModel]>?
    private var businessDataSource: DataSource<[Business]>?
    
    let validator = FormValidator()
    public var vehicle: Vehicle?
    public var didAddVehicle : ()->() = { _ in }
    
    @IBOutlet weak var carNickname: UITextField!
    @IBOutlet weak var carRegistration: UITextField!
    @IBOutlet weak var vehicleMakeLabel: ActiveLabel!
    @IBOutlet weak var vehicleModelLabel: ActiveLabel!
    @IBOutlet weak var carYear: UITextField!
    @IBOutlet weak var pickerView: AKPickerView!
    @IBOutlet weak var businessLabel: ActiveLabel?
    
    var vehicleMake : VehicleMake? { didSet { configureVehicleMake() } }
    var vehicleModel : VehicleModel? { didSet { configureVehicleModel() } }
    var business: Business? { didSet { configureBusiness() } }
    
    lazy var vehicleMakePicker: AbstractActionSheetPicker = { [unowned self] in
        self.stringPickerWithRows(rows: self.vehicleMakeDataSource!.items!.map { $0.name} , selectedRow: self.vehicleMake!.name, doneBlock: { [unowned self] (value) in
            self.vehicleMake = self.vehicleMakeDataSource!.items?.first(where: {$0.name == value})
            }, origin: self.vehicleMakeLabel)
        }()
    
    var vehicleModelPicker: AbstractActionSheetPicker!
    var businessPicker: AbstractActionSheetPicker!
    
    private func stringPickerWithRows(rows: [String], selectedRow: String, doneBlock: @escaping (String) -> Void, origin: Any) -> ActionSheetStringPicker {
        return ActionSheetStringPicker(title: "", rows: rows, initialSelection: rows.index(of: selectedRow) ?? 0, doneBlock: {
            picker, index, value in
            doneBlock(value as! String)
            return
        }, cancel: nil, origin: origin)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupValidation()
        
        if (self.businessLabel) != nil {
            self.setupBusinessDataSource()
            self.businessDataSource?.reload()
        }
        
        self.setupVehicleDataSource()
        self.vehicleMakeDataSource?.reload()
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.pickerViewStyle = .styleFlat
        self.pickerView.interitemSpacing = 40.0
    }
    
    func setupValidation() {
        validator.setRules(ruleSet: ValidationRules.nonEmpty, forControl: carRegistration)
        validator.setRules(ruleSet: ValidationRules.nonEmpty, forControl: carNickname)
        validator.setRules(ruleSet: ValidationRules.year, forControl: carYear)
    }
    
    private func setupVehicleDataSource() {
        vehicleMakeDataSource = DataSource(requestSender: AppDelegate.current().requestSender, apiRequest: ApiEndpoints.Vehicles.vehicleMakeRequest())
        
        vehicleMakeDataSource!.onStateUpdated = { [weak self] dataSource, state in
            self?.handleDataLoading(withDataSource: dataSource, state: state, contentReloadHandler: { [weak self] in
                self?.updateVehicleMakes()
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
    
    private func setupVehicleDataSource(makeId: String) {
        vehicleModelDataSource = DataSource(requestSender: AppDelegate.current().requestSender, apiRequest: ApiEndpoints.Vehicles.vehicleModelRequest(makeId: makeId))
        
        vehicleModelDataSource!.onStateUpdated = { [weak self] dataSource, state in
            self?.handleDataLoading(withDataSource: dataSource, state: state, contentReloadHandler: { [weak self] in
                self?.updateVehicleModel()
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
    
    private func setupBusinessDataSource() {
        businessDataSource = DataSource(requestSender: AppDelegate.current().requestSender, apiRequest: ApiEndpoints.Account.businessList())
        
        businessDataSource!.onStateUpdated = { [weak self] dataSource, state in
            self?.handleDataLoading(withDataSource: dataSource, state: state, contentReloadHandler: { [weak self] in
                self?.configureBusiness()
                self?.updateBusiness()
                }, loadingStateHandler: { [weak self]  (loadingState) in
                    switch loadingState {
                    case .started:
                       // self?.showProgress()
                        break
                    case .ended( _):
                       // self?.hideProgress()
                        self?.businessLabel!.isHidden = (self?.businessDataSource!.items  == nil)
                        break
                        
                    }
            })
        }
    }
    
    func nextButtonDidPressed() -> Bool {
        switch validator.validate() {
        case .valid:
            self.addVehicle(parameters: self.getParameters())
            return true
        case .invalid:
            validator.displayValidationStatus()
            return false
        }
    }
    
    private func configureVehicleMake() {
        guard let make = vehicleMake else {
            return
        }
        
        vehicleMakeLabel.customize { [unowned self] (label) in
            label.text = make.name
            self.addPicker(picker: self.vehicleMakePicker, withType: ActiveType.custom(pattern: "\\Q" + make.name + "\\E"), toLabel: label)
        }
        
        self.setupVehicleDataSource(makeId: make.id)
        self.vehicleModelDataSource?.reload()
    }
    
    private func configureVehicleModel() {
        
        guard let model = vehicleModel else {
            return
        }
        
        self.vehicleModelPicker = { [unowned self] in
            self.stringPickerWithRows(rows: self.vehicleModelDataSource!.items!.map { $0.name} , selectedRow: self.vehicleModel!.name, doneBlock: { [unowned self] (value) in
                self.vehicleModel = self.vehicleModelDataSource!.items?.first(where: {$0.name == value})
                }, origin: self.vehicleModelLabel)
            }()
        
        vehicleModelLabel.customize { [unowned self] (label) in
            label.text = model.name
            self.addPicker(picker: self.vehicleModelPicker, withType: ActiveType.custom(pattern: "\\Q" + model.name + "\\E"), toLabel: label)
        }
        
        self.pickerView.selectItem(UInt(model.vehicleType().rawValue - 1), animated: true)
    }
    
    private func configureBusiness() {
        
        guard (self.businessDataSource!.items?.count)! > 0 else {
            businessLabel!.isHidden = true
            return
        }
        
        var titles = [R.string.localized.vehicleNoBusinessTitle()]
        titles.append(contentsOf: self.businessDataSource!.items!.map { $0.name})
        
        var selectedTitle = titles.first
        
        if let currentBusiness = self.business {
            selectedTitle = currentBusiness.name
        }
        
        self.businessPicker = { [unowned self] in
            self.stringPickerWithRows(rows: titles, selectedRow: selectedTitle!, doneBlock: { [unowned self] (value) in
                self.business = self.businessDataSource?.items?.first(where: {$0.name == value}) ?? nil
            }, origin: self.businessLabel!)
        }()
        
        businessLabel?.customize { [unowned self] (label) in
            if let currentBusiness = self.business {
                label.text = currentBusiness.name
                self.addPicker(picker: self.businessPicker, withType: ActiveType.custom(pattern: "\\Q" + currentBusiness.name + "\\E"), toLabel: label)
            } else {
                label.text = R.string.localized.vehicleAddToBusinessTitle()
                self.addPicker(picker: self.businessPicker, withType: ActiveType.custom(pattern: "\\Q" + R.string.localized.vehicleAddToBusinessTitle() + "\\E"), toLabel: label)
            }
        }
    }

    private func updateVehicleMakes() {
        
        if let currentVehicle = self.vehicle {
            if let makeList = self.vehicleMakeDataSource?.items {
                guard let vehicleMake = currentVehicle.makeName else {
                    return
                }
                self.vehicleMake = makeList.first(where: {$0.name == vehicleMake})
            }
        } else {
            guard let make = self.vehicleMakeDataSource?.items?.first else {
                return
            }
            
            self.vehicleMake = make
        }
    }
    
    private func updateVehicleModel() {
        if let currentVehicle = self.vehicle {
            if let modelList = self.vehicleModelDataSource?.items {
                if self.vehicleModel == nil {
                    guard let vehiclemodelId = currentVehicle.vehiclemodelId else {
                        return
                    }
                    self.vehicleModel = modelList.first(where: {$0.id == vehiclemodelId})
                } else {
                    guard let model = self.vehicleModelDataSource?.items?.first else {
                        return
                    }
                    self.vehicleModel = model
                }
            }
        } else {
            guard let model = self.vehicleModelDataSource?.items?.first else {
                return
            }
            self.vehicleModel = model
        }
    }
    
    private func updateBusiness() {
        if let currentVehicle = self.vehicle {
            if let businessList = self.businessDataSource?.items {
                if self.business == nil {
                    guard let businessId = currentVehicle.businessId else {
                        return
                    }
                    self.business = businessList.first(where: {$0.id == businessId})
                }
            }
        }
    }
    
    private func addPicker(picker: AbstractActionSheetPicker, withType type: ActiveType, toLabel label: ActiveLabel) {
        label.customColor[type] = R.color.kneetly.textGray()
        label.handleCustomTap(for: type) { _ in
            picker.show()
        }
        label.enabledTypes.append(type)
    }
    
    func getParameters() -> [String: Any] {
        var parameters : [String: Any] = [:]
        
        if let makeId = self.vehicleMake?.id {
            parameters.updateValue(makeId, forKey: "makeId")
        }
        if let nickname = self.carNickname.text {
            parameters.updateValue(nickname, forKey: "nickname")
        }
        
        if let registration = self.carRegistration.text {
            parameters.updateValue(registration, forKey: "registration")
        }
        
        if let vehicleyear = Int(self.carYear.text!) {
            parameters.updateValue(vehicleyear, forKey: "vehicleyear")
        }
        
        if let model = self.vehicleModel {
            parameters.updateValue(model.id, forKey: "vehiclemodel_id")
        }
        
        if let business = self.business {
            parameters.updateValue(business.id, forKey: "business_id")
        } else {
            parameters.updateValue("", forKey: "business_id")
        }

        return parameters
    }
    
    func addVehicle(parameters : [String : Any]) {
        
        showProgress()
        
        let request = ApiEndpoints.Vehicles.addVehicle(parameters: parameters)
        AppDelegate.current().requestSender!.sendRequest(apiRequest: request, completion: { (result) in
            self.hideProgress()
            switch result {
            case .success(_):
                self.didAddVehicle()
                break
            case .failure(let error):
                KneetlyAlert.show(errorMessage: error.message ?? "" )
                break
            }
        })
    }
}

extension RegisterVehicleViewController: AKPickerViewDelegate, AKPickerViewDataSource {
    
    func numberOfItems(in pickerView: AKPickerView!) -> UInt {
        return UInt(CarType.allValues.count)
    }
    
    public func pickerView(_ pickerView: AKPickerView, imageForItem item: Int) -> UIImage {
        return CarType.allValues[item].image!
    }
}

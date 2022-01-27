//
//  Created by Suresh.
//  Copyright © 2016 Be IT Safe Pty Ltd. All rights reserved.
//

import UIKit
import MTLLinkLabel
import ActionSheetPicker_3_0
import KneetlyCommon
import SwiftDate

class InterviewViewController: MascotAnimatedViewController {
    
    var planningWash: Wash!
    
    private var vehiclesDataSource: DataSource<[Vehicle]>?
    
    private var washTypesDataSource: DataSource<[WashType]>?
    
    private var carPicker: AbstractActionSheetPicker?
    
    private var washTypePicker: AbstractActionSheetPicker?
    
    private lazy var dateAndTimePicker: AbstractActionSheetPicker = { [unowned self] in
        
        self.timePicker(doneBlock: { (date) in
            let useNow = (date.timeIntervalSince(Date()) / 60.0).isLess(than: 30)
            self.planningWash.scheduledTime = (useNow && self.planningWash.isWasherOnline) ? nil : date
            self.configureLabel()
        }, origin: self.infoLabel)
    }()

    private lazy var locationPicker: AbstractActionSheetPicker = { [unowned self] in
        self.stringPickerWithRows(rows: WashLocationType.allDescriptions, selectedRow: self.planningWash.locationType.description, doneBlock: { (value, index) in
            self.planningWash.locationType = WashLocationType.allValues.first(where: { $0.description == value })!
            self.configureLabel()
        }, origin: self.infoLabel)
    }()
    
    // MARK: Outlets

    @IBOutlet private weak var submitButton: UIButton!
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    @IBOutlet private weak var infoLabel: LinkLabel!
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        setupVehiclesDataSource()
    }
    
    private func setupVehiclesDataSource() {
        vehiclesDataSource = DataSource(requestSender: AppDelegate.current().requestSender, apiRequest: ApiEndpoints.Vehicles.vehicleListRequest())
        
        vehiclesDataSource?.onStateUpdated = { [weak self] dataSource, state in
            self?.handleDataLoading(withDataSource: dataSource, state: state, contentReloadHandler: { [weak self] in
                self?.setupCarPicker()
                self?.setupWashTypesDataSource(forVehicleType: self?.planningWash.vehicleType)
                }, loadingStateHandler: { [weak self]  (loadingState) in
                    switch loadingState {
                    case .started:
                        self?.activityIndicator.startAnimating()
                        self?.infoLabel.isHidden = true
                        self?.submitButton.isHidden = true
                    case .ended(let success):
                        self?.activityIndicator.stopAnimating()
                        self?.infoLabel.isHidden = !success
                        self?.submitButton.isHidden = !success
                    }
            })
        }
        vehiclesDataSource?.reload()
    }
    
    private func setupWashTypesDataSource(forVehicleType type: CarType?) {
        guard let type = type else {
            washTypePicker = nil
            return
        }
        
        washTypesDataSource = DataSource(requestSender: AppDelegate.current().requestSender, apiRequest: ApiEndpoints.WashRequest.washTypeRequest(forVehicleType: type))
        
        washTypesDataSource!.onStateUpdated = { [weak self] dataSource, state in
            self?.handleDataLoading(withDataSource: dataSource, state: state, contentReloadHandler: { [weak self] in
                self?.setupWashTypePicker()
                }, loadingStateHandler: { [weak self]  (loadingState) in
                    switch loadingState {
                    case .started:
                        self?.activityIndicator.startAnimating()
                        self?.infoLabel.isHidden = true
                        self?.submitButton.isHidden = true
                    case .ended(let success):
                        self?.activityIndicator.stopAnimating()
                        self?.infoLabel.isHidden = !success
                        self?.submitButton.isHidden = !success
                    }
            })
        }
        washTypesDataSource?.reload()
    }
    
    private func setupCarPicker() {
        guard let vehiclesDataSource = vehiclesDataSource, let items = vehiclesDataSource.items, let firstItem = items.first else {
            carPicker = nil
            return
        }
        
        if planningWash.vehicleId == nil {
            planningWash.vehicleId = firstItem.id
            planningWash.vehicleNickname = firstItem.nickname
            planningWash.vehicleType = firstItem.vehicleType()
        }
        
        carPicker = stringPickerWithRows(rows: items.map { $0.nickname! },
                                         selectedRow: planningWash.vehicleNickname!,
                                         doneBlock: { [unowned self] (value, index) in
                                            let selectedItem = self.vehiclesDataSource!.items!.first(where: { $0.nickname! == value })!
                                            self.planningWash.vehicleId = selectedItem.id
                                            self.planningWash.vehicleNickname = selectedItem.nickname
                                            
                                            if self.planningWash.vehicleType != selectedItem.vehicleType() {
                                                self.setupWashTypesDataSource(forVehicleType: selectedItem.vehicleType())
                                            }
                                            
                                            self.planningWash.vehicleType = selectedItem.vehicleType()
                                            self.configureLabel()
            },
                                         origin: infoLabel)
        
        configureLabel()
    }
    
    private func setupWashTypePicker() {
        guard let washTypesDataSource = washTypesDataSource, let items = washTypesDataSource.items, let firstItem = items.first else {
            washTypePicker = nil
            return
        }
        
        washTypePicker = stringPickerWithRows(rows: items.map { $0.name },
                                              selectedRow: firstItem.name,
                                              doneBlock: { [unowned self] (value, index) in
                                                self.planningWash.washTypeId = self.washTypesDataSource!.items!.first(where: {$0.name == value})!.id
                                                self.planningWash.washTypeName = value
                                                self.configureLabel()
            },
                                              origin: infoLabel)
        planningWash.washTypeId = firstItem.id
        planningWash.washTypeName = firstItem.name
        configureLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        performMascotAnimation()
    }
    
    // MARK: Actions 
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        showProgress()
        
        let request = ApiEndpoints.Booking.bookRequest(wash: planningWash)
        AppDelegate.current().requestSender.sendRequest(apiRequest: request, completion: { (result) in
            
            switch result {
            case .success(let bookingResult):
                if (self.planningWash.washerId != nil) {
                    self.performSegue(withIdentifier: R.segue.interviewViewController.toSearchForWasher, sender: bookingResult.bookingId)
                } else {
                    self.performSegue(withIdentifier: R.segue.interviewViewController.toConfirmBooking, sender: bookingResult.bookingId)
                }
            case .failure(let error):
                self.hideProgress()
                KneetlyAlert.show(errorMessage: error.message ?? "")
            }
        })
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dst = segue.destination as? ConfirmBookingViewController {
            dst.vehicleId = planningWash.vehicleId!
            dst.bookingId = sender as! String
        }
        if let dst = segue.destination as? SearchForWasherViewController {
            dst.bookingId = sender as! String
        }
    }
    
    // MARK: Private
    
    private static let currentTimeZoneDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: R.string.localized.commonDateFormatterLocale())
        formatter.amSymbol = R.string.localized.interviewDateFormatterAmSymbol()
        formatter.pmSymbol = R.string.localized.interviewDateFormatterPmSymbol()
        formatter.dateFormat = R.string.localized.interviewDateFormatterDateFormat()
        return formatter
    }()
    
    private func timePicker(doneBlock: @escaping (Date) -> Void, origin: UIView) -> AbstractActionSheetPicker {
        let minimumDate = planningWash.isWasherOnline ? Date() : Date() + 30.minutes
        let picker = ActionSheetDatePicker(title: "", datePickerMode: .dateAndTime, selectedDate: minimumDate, doneBlock: {
            picker, date, origin in
            doneBlock(date as! Date)
            return
        }, cancel: nil, origin: origin)!
        
        picker.locale = Locale(identifier: R.string.localized.commonDateFormatterLocale())
        picker.minimumDate = minimumDate
        
        return picker
    }
    
    private func stringPickerWithRows(rows: [String], selectedRow: String, doneBlock: @escaping (String, Int) -> Void, origin: Any) -> ActionSheetStringPicker {
        return ActionSheetStringPicker(title: "", rows: rows, initialSelection: rows.index(of: selectedRow) ?? 0, doneBlock: {
            picker, index, value in
            doneBlock(value as! String, index)
            return
        }, cancel: nil, origin: origin)
    }
    
    private func configureLabel() {
        guard let planningWash = planningWash, let vehicleNickname = planningWash.vehicleNickname, let washTypeName = planningWash.washTypeName else {
            return
        }
        
        let timeString = self.planningWash.scheduledTime != nil ? InterviewViewController.currentTimeZoneDateFormatter.string(from: self.planningWash.scheduledTime!) : R.string.localized.interviewTimeNow()
        
        
        infoLabel.text = R.string.localized.interviewInfoLabelPart1() + vehicleNickname + R.string.localized.interviewInfoLabelPart2() + timeString + R.string.localized.interviewInfoLabelPart3() + self.planningWash.locationType.description + R.string.localized.interviewInfoLabelPart4() + washTypeName + "."
        
        let part1Length = R.string.localized.interviewInfoLabelPart1().characters.count
        let vehicleNicknameLength = vehicleNickname.characters.count
        let part2Length = R.string.localized.interviewInfoLabelPart2().characters.count
        let timeStringLength = timeString.characters.count
        let part3Length = R.string.localized.interviewInfoLabelPart3().characters.count
        let locationLength = self.planningWash.locationType.description.characters.count
        let part4Length = R.string.localized.interviewInfoLabelPart4().characters.count
        let washTypeNameLength = washTypeName.characters.count
        
        let vehicleNicknameRange = NSRange(location: part1Length, length: vehicleNicknameLength)
        let timeStringRange = NSRange(location: vehicleNicknameRange.location + vehicleNicknameRange.length + part2Length, length: timeStringLength)
        let locationRange = NSRange(location: timeStringRange.location + timeStringRange.length + part3Length, length: locationLength)
        let washTypeNameRange = NSRange(location: locationRange.location + locationRange.length + part4Length, length: washTypeNameLength)
        
        _ = infoLabel.addLink(
            URL(string: "https://www.google.com")!,
            range: vehicleNicknameRange,
            linkAttribute: [
                NSForegroundColorAttributeName: R.color.kneetly.blue2()
            ]
        ) { [unowned self] (url) -> Void in
            self.carPicker?.show()
        }
        
        _ = infoLabel.addLink(
            URL(string: "https://www.google.com")!,
            range: timeStringRange,
            linkAttribute: [
                NSForegroundColorAttributeName: R.color.kneetly.blue2()
            ]
        ) { [unowned self] (url) -> Void in
            self.dateAndTimePicker.show()
        }

        _ = infoLabel.addLink(
            URL(string: "https://www.google.com")!,
            range: locationRange,
            linkAttribute: [
                NSForegroundColorAttributeName: R.color.kneetly.blue2()
            ]
        ) { [unowned self] (url) -> Void in
            self.locationPicker.show()
        }

        _ = infoLabel.addLink(
            URL(string: "https://www.google.com")!,
            range: washTypeNameRange,
            linkAttribute: [
                NSForegroundColorAttributeName: R.color.kneetly.blue2()
            ]
        ) { [unowned self] (url) -> Void in
            self.washTypePicker?.show()
        }
    }
}

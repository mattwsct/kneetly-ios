//
//  ChangeWashDetailsViewController.swift
//  KneetlyWashersApp
//
//  Created by Matt Westcott on 17/02/2017.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import KneetlyCommon
import UIKit
import Fusuma
import ActionSheetPicker_3_0
import ActiveLabel
import KMPlaceholderTextView
import IQKeyboardManagerSwift

class ChangeWashDetailsViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var washTypeLabel: ActiveLabel!
    @IBOutlet weak var vehicleLabel: ActiveLabel!
    @IBOutlet weak var refundAdditionalChargesLabel: UILabel!
    @IBOutlet weak var refundAdditionalChargesTextField: UITextField!
    @IBOutlet weak var washTypeHUD: UIActivityIndicatorView!
    @IBOutlet weak var vehicleHUD: UIActivityIndicatorView!
    @IBOutlet weak var descriptionTextView: KMPlaceholderTextView!
    
    var bookingId: String!
    var booking: BookingWash!
    
    private let fusuma = FusumaViewController()
    
    private var selectedWashType: WashType? { didSet { configuredWashTypes() } }
    private var selectedVehicle: Vehicle? { didSet { configuredVehicles() } }
    
    private var washTypesDataSource: DataSource<[WashType]>!
    private var vehiclesDataSource: DataSource<[Vehicle]>!
    
    private var washTypePicker: AbstractActionSheetPicker!
    private var carPicker: AbstractActionSheetPicker!
    
    private var updatedBookingPrice: Double {
        get {
            return selectedWashType?.price ?? 0
        }
    }
    private var priceDifference: Double {
        get {
            return (booking.price ?? 0) - updatedBookingPrice
        }
    }
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fusuma.delegate = self
        
        getBooking()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Actions
    
    @IBAction func addImage() {
        present(fusuma, animated: true, completion: nil)
    }
    
    @IBAction func saveChanges() {
        IQKeyboardManager.sharedManager().resignFirstResponder()
        let request = ApiEndpoints.WashChangeRequest.update(
            bookingId: bookingId,
            priceDifference: priceDifference,
            newWashTypeId: selectedWashType?.id,
            newVehicleId: selectedVehicle?.id,
            image: imageView.image,
            description: descriptionTextView.text
        )
        showProgress()
        AppDelegate.current().requestSender.sendRequest(apiRequest: request) { result in
            self.hideProgress()
            switch result {
            case .success(_):
                self.navigateBackAnimated()
            case .failure(let error):
                KneetlyAlert.show(errorMessage: error.message ?? "" )
            }
        }
    }
    
    // MARK: - Helpers
    
    private func getBooking() {
        showProgress()
        AppDelegate.current().requestSender.sendRequest(apiRequest: ApiEndpoints.LookingForJob.getBookingWash(id: bookingId)) { result in
            self.hideProgress()
            switch result {
            case .success(let booking):
                self.booking = booking
                self.washTypeHUD.startAnimating()
                self.configureWashTypes(vehicleType: booking.vehicleType, bookingWashTypeId: booking.washtypeId) {
                    self.washTypeHUD.stopAnimating()
                }
                self.vehicleHUD.startAnimating()
                self.configureVehicles(userId: booking.userId, bookingVehicleId: booking.vehicleId) {
                    self.vehicleHUD.stopAnimating()
                }
            case .failure(let error):
                KneetlyAlert.show(errorMessage: error.message ?? "")
            }
        }
    }
    
    private func configureWashTypes(vehicleType: CarType, bookingWashTypeId: Int?, completion: @escaping ()-> Void) {
        washTypesDataSource = DataSource(
            requestSender: AppDelegate.current().requestSender,
            apiRequest: ApiEndpoints.WashRequest.washTypeRequest(forVehicleType: vehicleType)
        )
        washTypesDataSource.reload() {
            self.washTypePicker = self.stringPickerWithRows(
                rows: self.washTypesDataSource.items!.map {$0.name},
                selectedRow: self.selectedWashType?.name ?? "",
                doneBlock: { [unowned self] value, index in
                    self.selectedWashType = self.washTypesDataSource.items?.first(where: {$0.name == value})
                },
                origin: self.washTypeLabel
            )
            if let index = self.washTypesDataSource.items?.index(where: {$0.id == bookingWashTypeId} ) {
                self.selectedWashType = self.washTypesDataSource.items?[index]
            } else {
                self.selectedWashType = self.washTypesDataSource.items?.first
            }
            completion()
        }
    }
    
    private func configureVehicles(userId: String, bookingVehicleId: String?, completion: @escaping ()-> Void) {
        vehiclesDataSource = DataSource(
            requestSender: AppDelegate.current().requestSender,
            apiRequest: ApiEndpoints.Vehicles.vehicleListRequest(userId: userId)
        )
        vehiclesDataSource.reload() { 
            self.carPicker = self.stringPickerWithRows(
                rows: self.vehiclesDataSource.items!.map { $0.nickname! },
                selectedRow: self.selectedVehicle?.nickname ?? "",
                doneBlock: { [unowned self] value, index in
                    self.selectedVehicle = self.vehiclesDataSource.items!.first(where: {$0.nickname! == value})
                    self.selectedWashType = nil
                    self.vehicleHUD.startAnimating()
                    self.configureWashTypes(vehicleType: self.selectedVehicle!.vehicleType(), bookingWashTypeId: nil) {
                        self.vehicleHUD.stopAnimating()
                    }
                },
                origin: self.vehicleLabel
            )
            if let index = self.vehiclesDataSource.items?.index(where: { $0.id == bookingVehicleId} ) {
                self.selectedVehicle = self.vehiclesDataSource.items?[index]
            } else {
                self.selectedVehicle = self.vehiclesDataSource.items?.first
            }
            completion()
        }
    }
    
    private func configuredWashTypes() {
        if let type = selectedWashType {
            washTypeLabel.customize { [unowned self] label in
                label.text = type.name
                self.addPicker(picker: self.washTypePicker, withType: ActiveType.custom(pattern: "\\Q" + type.name + "\\E"), toLabel: label)
            }
            calculateDifferenceAndUpdateUI()
        }
    }
    
    private func configuredVehicles() {
        if let vehicle = selectedVehicle {
            vehicleLabel.customize { [unowned self] label in
                label.text = vehicle.nickname
                self.addPicker(picker: self.carPicker, withType: ActiveType.custom(pattern: "\\Q" + vehicle.nickname! + "\\E"), toLabel: label)
            }
        }
    }
    
    private func stringPickerWithRows(rows: [String], selectedRow: String, doneBlock: @escaping (String, Int) -> Void, origin: Any) -> ActionSheetStringPicker {
        return ActionSheetStringPicker(
            title: "",
            rows: rows,
            initialSelection: rows.index(of: selectedRow) ?? 0,
            doneBlock: { picker, index, value in
                doneBlock(value as! String, index)
                return
            },
            cancel: nil,
            origin: origin
        )
    }
    
    private func addPicker(picker: AbstractActionSheetPicker, withType type: ActiveType, toLabel label: ActiveLabel) {
        label.customColor[type] = R.color.kneetly.blue2()
        label.handleCustomTap(for: type) { _ in
            picker.show()
        }
        label.enabledTypes.append(type)
    }
    
    private func calculateDifferenceAndUpdateUI() {
        if priceDifference > 0 {
            refundAdditionalChargesLabel.text = R.string.localized.changeWashRefundText()
        } else if priceDifference == 0 {
            refundAdditionalChargesLabel.text = R.string.localized.changeWashRefundAdditionalChargesLabelText()
        } else {
            refundAdditionalChargesLabel.text = R.string.localized.changeWashAdditionalChargesText()
        }
        refundAdditionalChargesTextField.text = String(format: "$%.2f", abs(priceDifference))
    }
}

extension ChangeWashDetailsViewController: FusumaDelegate {
    
    public func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        imageView.image = image
    }
    
    public func fusumaVideoCompleted(withFileURL fileURL: URL) {
        print("Called just after a video has been selected.")
    }
    
    public func fusumaCameraRollUnauthorized() {
        print("Camera roll unauthorized")
    }
    
    public func fusumaDismissedWithImage(_ image: UIImage, source: FusumaMode) {
        
    }
    
    public func fusumaClosed() {
        
    }
}

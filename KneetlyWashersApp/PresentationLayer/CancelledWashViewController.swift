//
//  CancelledWashViewController.swift
//  KneetlyWashersApp
//
//  Created by Matt Westcott on 02/02/2017.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import UIKit
import KneetlyCommon
import ActionSheetPicker_3_0
import ActiveLabel
import KMPlaceholderTextView

class  CancelledWashViewController: UIViewController {
    
    var bookingId: String!
    
    var didFinishHandler: (() -> Void)!
    
    private var reasonsDataSource: DataSource<[CancellationCategory]>?
    private var reason : CancellationCategory? { didSet { configureReason() } }
    @IBOutlet weak var reasonLabel: ActiveLabel!
    @IBOutlet weak var commentsTextView: KMPlaceholderTextView!
    
    private lazy var reasonsPicker: AbstractActionSheetPicker = { [unowned self] in
        self.stringPickerWithRows(rows: self.reasonsDataSource!.items!.map { $0.name} , selectedRow: self.reason!.name, doneBlock: { [unowned self] (value) in
            self.reason = self.reasonsDataSource!.items?.first(where: {$0.name == value})
            }, origin: self.reasonLabel)
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupDataSource()
        self.reasonsDataSource?.reload()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func stringPickerWithRows(rows: [String], selectedRow: String, doneBlock: @escaping (String) -> Void, origin: Any) -> ActionSheetStringPicker {
        return ActionSheetStringPicker(title: "", rows: rows, initialSelection: rows.index(of: selectedRow) ?? 0, doneBlock: {
            picker, index, value in
            doneBlock(value as! String)
            return
        }, cancel: nil, origin: origin)
    }
    
    func configureReason() {
        guard let cancellationReason = reason else {
            return
        }
        
        reasonLabel.customize { [unowned self] (label) in
            label.text = cancellationReason.name
            self.addPicker(picker: self.reasonsPicker, withType: ActiveType.custom(pattern: "\\Q" + cancellationReason.name + "\\E"), toLabel: label)
        }
    }
    
    private func addPicker(picker: AbstractActionSheetPicker, withType type: ActiveType, toLabel label: ActiveLabel) {
        label.customColor[type] = R.color.kneetly.textGray()
        label.handleCustomTap(for: type) { _ in
            picker.show()
        }
        label.enabledTypes.append(type)
    }
    
    private func setupDataSource() {
        self.reasonsDataSource = DataSource(requestSender: AppDelegate.current().requestSender, apiRequest: ApiEndpoints.LookingForJob.cancellationCategoryRequest())
        
        self.reasonsDataSource!.onStateUpdated = { [weak self] dataSource, state in
            self?.handleDataLoading(withDataSource: dataSource, state: state, contentReloadHandler: { [weak self] in
                self?.updateReason()
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
    
    private func updateReason() {
        guard let firstReason = self.reasonsDataSource?.items?.first else {
            return
        }
        self.reason = firstReason
    }
    
    @IBAction func sibmitButtonTapped(_ sender: Any) {
        guard let cancellationReason = reason else {
            return
        }
        
        showProgress()
        
        let request = ApiEndpoints.LookingForJob.rejectRequest(bookingId: self.bookingId, categoriesId: cancellationReason.id, comments: self.commentsTextView.text ?? "")
        AppDelegate.current().requestSender!.sendRequest(apiRequest: request, completion: { (result) in
            self.hideProgress()
            switch result {
            case .success(_):
                self.didFinishHandler()
            case .failure(let error):
                KneetlyAlert.show(errorMessage: error.message ?? "" )
            }
        })
    }
}

//
//  PreWashChecklistViewController.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 15/12/2016.
//  Copyright © 2016 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import UIKit

public enum DamagesScreenState : Int {
    case userSubmit
    case waitingForWasher
    case userConfirm
    case washerSubmit
    case waitingForClient
    case startWash
    
    var buttonTitle: String {
        switch self {
        case .userSubmit, .washerSubmit:
            return R.string.localized.damageSubmitStateButtonTitle()
        case .waitingForWasher:
            return R.string.localized.damageWaitingForWasherStateButtonTitle()
        case .userConfirm:
            return R.string.localized.damageConfirmStateButtonTitle()
        case .waitingForClient:
            return R.string.localized.damageWaitingForClientStateButtonTitle()
        case .startWash:
            return R.string.localized.damageStartWashStateButtonTitle()
        }
    }
    
    var buttonColor: UIColor {
        switch self {
        case .userSubmit, .userConfirm, .washerSubmit, .startWash:
            return R.color.kneetly.green2()
        case .waitingForWasher, .waitingForClient:
            return R.color.kneetly.textGray()
        }
    }
    
    var canEdit: Bool {
        switch self {
        case .userSubmit, .washerSubmit:
            return true
        case .waitingForWasher, .waitingForClient, .userConfirm, .startWash:
            return false
        }
    }
    
    var canActiveButton: Bool {
        switch self {
        case .userSubmit, .washerSubmit, .startWash, .userConfirm:
            return true
        case .waitingForWasher, .waitingForClient:
            return false
        }
    }
}

public enum TargetType: String {
    case none = ""
    case user = "users"
    case washer = "washer"
}

public class PreWashChecklistViewController : UIViewController {
    
    @IBOutlet weak var damagesView: DamagesView!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var interriorDamageButton: UIButton!
    
    private var state : DamagesScreenState = .userSubmit { didSet { updateScreenState() } }
    private var targetType: TargetType = .none
    private var damagesDataSource: DataSource<[Damage]>?
    private var bookingId: String!
    private var selectedDamage: Damage?
    private var newDamagePoint: DamagePoint?
    private var selectedDamageType: DamageType = .exterior
    private var hasChanges: Bool = false
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupDamagesDataSource()
        self.damagesDataSource?.reload()
        
        self.damagesView.onSelectDamage = { damage in
            self.selectedDamage = damage
            self.newDamagePoint = nil
            self.selectedDamageType = .exterior
            self.performSegue(withIdentifier: R.segue.preWashChecklistViewController.toDamageDetails.identifier, sender: self)
        }
        
        self.damagesView.onAddNewDamagePoint = { point in
            if self.state.canEdit == true {
                self.newDamagePoint = point
                self.selectedDamage = nil
                self.selectedDamageType = .exterior
                self.performSegue(withIdentifier: R.segue.preWashChecklistViewController.toDamageDetails.identifier, sender: self)
            }
        }
        
        self.updateScreenState()
    }
    
    public func configure(targetType: TargetType, bookingId: String, state: DamagesScreenState) {
        self.bookingId = bookingId
        self.targetType = targetType
        self.state = state
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    private func setupDamagesDataSource() {
        self.damagesDataSource = DataSource(requestSender: BaseAppDelegate.current().requestSender, apiRequest: ApiEndpoints.Damages.damagesListRequest(bookingId: self.bookingId, consumer: self.targetType.rawValue))
        
        self.damagesDataSource?.onStateUpdated = { [weak self] dataSource, state in
            self?.handleDataLoading(withDataSource: dataSource, state: state, contentReloadHandler: { [weak self] in
                self?.updateDamages()
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
    
    func updateDamages() {
        guard let damages = self.damagesDataSource?.items else {
            return
        }
        
        let interiorDamage = damages.filter{ $0.type == 1}.first
        interriorDamageButton.backgroundColor = (interiorDamage == nil) ? R.color.kneetly.textGray() : UIColor.red
        
        self.damagesView.update(damages: damages)
    }
    
    func updateScreenState() {
        self.hasChanges = false
        if let button = self.actionButton {
            button.setTitle(self.state.buttonTitle, for: .normal)
            button.tintColor = self.state.buttonColor
            button.isUserInteractionEnabled = self.state.canActiveButton
        }
        
        if let damageview = self.damagesView {
            damageview.canAdd = self.state.canEdit
        }
    }
    
    @IBAction func actionButtonWasTapped(sender: UIButton! = nil) {
        switch state {
        case .userSubmit:
            self.userSubmit()
            break
        case .waitingForWasher:
            break
        case .userConfirm:
            self.userConfirmation()
            break
        case .washerSubmit:
            self.washerSubmit()
            break
        case .waitingForClient:
            break
        case .startWash:
            self.startWash()
            break
        }
    }
    
    func userSubmit() {
        self.state = .waitingForWasher
    }
    
    func userConfirmation() {
        showProgress()
        BaseAppDelegate.current().requestSender!.sendRequest(apiRequest: ApiEndpoints.Damages.userConfirmation(bookingId: self.bookingId), completion: { (result) in
            self.hideProgress()
            switch result {
            case .success(_):
                self.performSegue(withIdentifier: R.segue.preWashChecklistViewController.toWashInProgress.identifier, sender: self)
                break
            case .failure(let error):
                KneetlyAlert.show(errorMessage: error.message ?? "")
                break
            }
        })
    }
    
    func washerSubmit() {
        showProgress()
        BaseAppDelegate.current().requestSender!.sendRequest(apiRequest: ApiEndpoints.Damages.washerSubmit(bookingId: self.bookingId), completion: { (result) in
            self.hideProgress()
            switch result {
            case .success(_):
                self.state = (self.hasChanges == true) ? .waitingForClient : .startWash
                break
            case .failure(let error):
                KneetlyAlert.show(errorMessage: error.message ?? "")
                break
            }
        })
    }
    
    func startWash() {
        showProgress()
        BaseAppDelegate.current().requestSender!.sendRequest(apiRequest: ApiEndpoints.Damages.startWash(bookingId: self.bookingId), completion: { (result) in
            self.hideProgress()
            switch result {
            case .success(_):
                self.performSegue(withIdentifier: R.segue.preWashChecklistViewController.toWashInProgressWashers.identifier, sender: self)
                break
            case .failure(let error):
                KneetlyAlert.show(errorMessage: error.message ?? "")
                break
            }
        })
    }
    
    @IBAction func addInteriorDamage(sender: UIButton! = nil) {
        if let damages = self.damagesDataSource?.items {
            self.selectedDamage = damages.filter{ $0.type == 1}.first
        } else {
            self.selectedDamage = nil
        }
        
        if self.selectedDamage == nil && self.state.canEdit == false {
            return
        }
        self.selectedDamageType = .interior
        self.performSegue(withIdentifier: R.segue.preWashChecklistViewController.toDamageDetails.identifier, sender: self)
    }
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.preWashChecklistViewController.toDamageDetails.identifier {
            
            if (self.state.canEdit == false && self.selectedDamage == nil && self.selectedDamageType == .exterior) {
                return
            }
            let viewController = segue.destination as! DamageDetailsViewController
            
            viewController.configure(targetType: self.targetType, bookingId: self.bookingId, damageType: self.selectedDamageType, damage: self.selectedDamage ?? nil, newDamagePoint: self.newDamagePoint ?? nil, canEdit: self.state.canEdit)
            
            viewController.onUpdateDamages =  {
                self.damagesDataSource?.reload()
                self.hasChanges = true
            }
        } else if (segue.identifier == R.segue.preWashChecklistViewController.toWashInProgressWashers.identifier || segue.identifier == R.segue.preWashChecklistViewController.toWashInProgress.identifier) {
            let viewController = segue.destination as! CommonWashInProgressViewController
            viewController.configure(bookingId: self.bookingId)
        }
        
        
    }
}

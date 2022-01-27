//
//  DamageDetailsViewController.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 15/12/2016.
//  Copyright © 2016 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import UIKit
import Fusuma
import KMPlaceholderTextView

public class DamageDetailsViewController: UIViewController {
    
    @IBOutlet weak var damageImage: UIImageView!
    @IBOutlet weak var damageDescription: KMPlaceholderTextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var saveButton: KneetlyButton!
    
    private var damage: Damage?
    private var newDamagePoint: DamagePoint?
    private var damageType: DamageType = .interior
    private var canEdit: Bool = true
    public var onUpdateDamages : ()->() = { _ in }
    private var targetType: TargetType = .none
    private var bookingId: String!
    private let fusuma = FusumaViewController()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.fusuma.delegate = self
        self.damageDescription.delegate = self
        fusumaTintColor = R.color.kneetly.green2()
        
        if let description = damage?.description {
            self.damageDescription.text = self.damage?.description
        }
        
        self.damageDescription.isHidden = (canEdit == false && self.damageDescription.hasText == false)
        
        if let imageUrl = self.damage?.imageUrl {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            self.damageImage.imageFromUrl(urlString: imageUrl, complition: {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            })
        }
        self.damageImage.layer.cornerRadius = 16.0
        self.damageImage.clipsToBounds = true
        self.removeButton.isHidden = (canEdit == false)
        self.saveButton.isHidden = (canEdit == false)
        self.saveButton.setEnabled(isEnabled: self.damageDescription.hasText)
        self.damageDescription.isUserInteractionEnabled = (canEdit == true)
    }
    
    func configure(targetType: TargetType, bookingId: String, damageType: DamageType, damage: Damage?, newDamagePoint: DamagePoint?, canEdit: Bool = true) {
        self.bookingId = bookingId
        self.targetType = targetType
        self.damageType = damageType
        self.damage = damage
        self.newDamagePoint = newDamagePoint
        self.canEdit = canEdit
    }
    
    override public func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        if parent == nil {
            if let point = self.newDamagePoint {
                point.pointView.removeFromSuperview()
                self.newDamagePoint = nil
            }
        }
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    func getParameters() -> [String: Any] {
        var parameters : [String: Any] = [:]
        
        if let point = self.newDamagePoint {
            parameters.updateValue(Double(point.xPosition), forKey: "damage[xcoordinate]")
            parameters.updateValue(Double(point.yPosition), forKey: "damage[ycoordinate]")
        }
        
        if let point = self.damage?.damagePoint {
            parameters.updateValue(Double(point.xPosition), forKey: "damage[xcoordinate]")
            parameters.updateValue(Double(point.yPosition), forKey: "damage[ycoordinate]")
        }
        
        if let description = self.damageDescription.text {
            parameters.updateValue(description, forKey: "damage[description]")
        }
        
        parameters.updateValue((self.damageType == .interior) ? 1 : 0, forKey: "damage[type]")
        
        return parameters
    }
    
    @IBAction func saveDamage(sender: UIButton! = nil) {
        var request : ApiRequest<ApiObject, ApiErrorCategory<ApiDefaultError>>!
        if let damageToUpdate = self.damage {
            request = ApiEndpoints.Damages.updateDamageRequest(bookingId: self.bookingId, damageId: damageToUpdate.id, parameters: self.getParameters(), image: self.damageImage.image, consumer: self.targetType.rawValue)
        } else {
            request = ApiEndpoints.Damages.addDamageRequest(bookingId: self.bookingId, parameters: self.getParameters(),image: self.damageImage.image, consumer: self.targetType.rawValue)
        }
        showProgress()

        BaseAppDelegate.current().requestSender!.sendRequest(apiRequest: request, completion: { (result) in
            self.hideProgress()
            switch result {
            case .success(_):
                self.navigationController?.popViewController(animated: true)
                self.onUpdateDamages()
                break
            case .failure(let error):
                KneetlyAlert.show(errorMessage: error.message ?? "")
                break
            }
        })
    }
    
    @IBAction func remove(sender: UIButton! = nil) {
        if let damageToRemove = self.damage {
            showProgress()
            
            let request = ApiEndpoints.Damages.removeDamageRequest(bookingId: self.bookingId, damageId: damageToRemove.id, consumer: self.targetType.rawValue)
            BaseAppDelegate.current().requestSender!.sendRequest(apiRequest: request, completion: { (result) in
                self.hideProgress()
                switch result {
                case .success(_):
                    self.navigationController?.popViewController(animated: true)
                    self.onUpdateDamages()
                    break
                case .failure(let error):
                    KneetlyAlert.show(errorMessage: error.message ?? "")
                    break
                }
            })
            
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func addImage(sender: UIButton! = nil) {
        if self.canEdit == true {
            self.present(fusuma, animated: true, completion: nil)
        }
    }
}

extension DamageDetailsViewController: FusumaDelegate {

    public func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        self.damageImage.image = image
        self.saveButton.setEnabled(isEnabled: self.damageDescription.hasText == true || self.damageImage.image != nil)
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

extension DamageDetailsViewController: UITextViewDelegate {
    
    public func textViewDidChange(_ textView: UITextView) {
        self.saveButton.setEnabled(isEnabled: textView.hasText == true || self.damageImage.image != nil)
    }
}

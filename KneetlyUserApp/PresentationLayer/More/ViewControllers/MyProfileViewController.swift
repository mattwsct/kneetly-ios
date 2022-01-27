//
//  MyProfileViewController.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 17.01.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import KneetlyCommon

class MyProfileViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var businaeesNameLabel: UILabel!
    @IBOutlet weak var locationStoreSwitch: UISwitch!
    
    var user: User!
    var business: Business?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getProfile()
        locationStoreSwitch.isOn = Preferences.isLocationStoreAllowed()
    }
    
    func getProfile() {
        showProgress()
        let request = ApiEndpoints.Account.profileRequest()
        AppDelegate.current().requestSender!.sendRequest(apiRequest: request, completion: { (result) in
            self.hideProgress()
            self.getBusiness()
            switch result {
            case .success(let currentUser):
                self.user = currentUser
                let firstname = currentUser.firstName ?? ""
                let lastname = currentUser.lastName ?? ""
                self.usernameLabel.text = "\(firstname) \(lastname)"
                break
            case .failure( _):
                break
            }
        })
    }
    
    func getBusiness() {
        showProgress()
        let request = ApiEndpoints.Account.businessList()
        AppDelegate.current().requestSender!.sendRequest(apiRequest: request, completion: { (result) in
            self.hideProgress()
            switch result {
            case .success(let businessList):
                if let currentBusiness = businessList.first {
                    self.business = currentBusiness
                    let name = currentBusiness.name ?? ""
                    self.businaeesNameLabel.text = "\(name)"
                }
                break
            case .failure( _):
                break
            }
        })
    }
    
    @IBAction func locationStoreSwitchValueChanged(_ sender: UISwitch) {
        Preferences.setLocationStoreAllowed(sender.isOn)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dst = segue.destination as? UpdateProfileViewController {
            dst.user = self.user
            dst.didUpdateProfile = {
                _ = self.navigationController?.popViewController(animated: true)
                self.getProfile()
            }
        }
        
        if let dst = segue.destination as? BusinessViewController {
            dst.business = business
            dst.didUpdateBusiness = {
                _ = self.navigationController?.popViewController(animated: true)
                self.getBusiness()
            }
        }
    }

}

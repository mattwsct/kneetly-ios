//
//  ProfileViewController.swift
//  KneetlyWashersApp
//
//  Created by Matt Westcott on 07.02.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import KneetlyCommon

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var profile: User!
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerLabel.text = R.string.localized.profileHeaderTitle()
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        
        updateProfile()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateProfile),
            name: NotificationCenterDefault.Profile.Updated,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: NotificationCenterDefault.Profile.Updated,
            object: nil
        )
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case R.segue.profileViewController.toEditProfile.identifier:
            if let editProfileVC = segue.destination as? EditProfileViewController {
                editProfileVC.profile = profile
            }
        default: break
        }
    }
    
    // MARK: - Actions
    
    func updateProfile() {
        showProgress()
        let request = ApiEndpoints.ProfileRequest.getProfile()
        AppDelegate.current().requestSender!.sendRequest(
            apiRequest: request,
            completion: { result in
                self.hideProgress()
                switch result {
                case .success(let profile):
                    self.profile = profile
                    self.tableView.reloadData()
                case .failure(let error):
                    KneetlyAlert.show(errorMessage: error.message ?? "")
                }
            }
        )
    }
}

extension ProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profile != nil ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.profileCell, for: indexPath)!
        cell.configure(profile: profile)
        return cell
    }
}

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: R.segue.profileViewController.toEditProfile, sender: nil)
    }
}

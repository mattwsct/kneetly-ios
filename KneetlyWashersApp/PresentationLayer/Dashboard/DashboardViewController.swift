//
//  DashboardViewController.swift
//  KneetlyWashersApp
//
//  Created by Matt Westcott on 1/30/17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import KneetlyCommon
import HCSStarRatingView

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var myRatingView: HCSStarRatingView!
    
    @IBOutlet weak var myRatingLabel: UILabel!
    
    private var profile: User! {
        didSet {
            myRatingLabel.text = "\(profile.rating)"
            myRatingView.value = CGFloat(profile.rating)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(popToLookingForUser),
            name: NSNotification.Name.Navigation.navigateToLookingForUser,
            object: nil
        )
        
        getProfile()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.Navigation.navigateToLookingForUser, object: nil)
    }
    
    func popToLookingForUser() {
        if let tabbar = self.tabBarController as? TabBarController {
            tabbar.show(vc: R.storyboard.dashboard().instantiateViewController(withIdentifier: R.storyboard.dashboard.lookingForUserViewController.identifier), tabIndex: .dashboard)
        }
    }
    
    private func getProfile() {
        let request = ApiEndpoints.ProfileRequest.getProfile()
        AppDelegate.current().requestSender!.sendRequest(
            apiRequest: request) { result in
                self.hideProgress()
                switch result {
                case .success(let profile):
                    self.profile = profile
                case .failure(let error):
                    KneetlyAlert.show(errorMessage: error.message ?? "")
                }
        }
    }
}

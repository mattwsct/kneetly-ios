//
//  LookingForUserViewController.swift
//  KneetlyWashersApp
//
//  Created by Matt Westcott on 01/02/2017.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import UIKit
import KneetlyCommon

class LookingForUserViewController: UIViewController {
    
    // MARK: - View controller lifecycle

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Actions
    
    @IBAction func gofflineButtonTapped(_ sender: Any) {
        showProgress()
        
        let request = ApiEndpoints.LookingForJob.goOfflineRequest()
        AppDelegate.current().requestSender!.sendRequest(apiRequest: request, completion: { (result) in
            self.hideProgress()
            switch result {
            case .success(_):
                _ = self.navigationController?.popToRootViewController(animated: true)
                break
            case .failure(let error):
                KneetlyAlert.show(errorMessage: error.message ?? "" )
                break
            }
        })
    }
}

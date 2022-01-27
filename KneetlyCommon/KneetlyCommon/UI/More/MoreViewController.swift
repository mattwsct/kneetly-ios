//
//  MoreViewController.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 17.02.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit

open class MoreViewController: UIViewController {

    // MARK: - View controller lifecycle
    
    open override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Actions
    
    @IBAction func logoutDidPressed() {
        showProgress()
        AuthentificationManager.sharedInstance.logout() { error in
            self.hideProgress()
            
            if let error = error {
                KneetlyAlert.show(errorMessage: error.message ?? "")
            }
            else {
                BaseAppDelegate.current().showLoginScreen()
            }
        }
        
    }
}

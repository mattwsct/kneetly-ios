//
//  RegisterPaymentTermsConditionsContainerViewController.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 31/01/2017.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import KneetlyCommon

class RegisterPaymentTermsConditionsContainerViewController: UIViewController, WizardPage {
    
    @IBOutlet weak var closeBarButtonItem: UIBarButtonItem! {
        didSet {
            closeBarButtonItem.title = R.string.localized.commonClose()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.registerPaymentTermsConditionsContainerViewController.embedTermsConditions.identifier {
            if let termsConditionsVC = segue.destination as? TermsConditionsViewController {
                let request = ApiEndpoints.TermsAndConditions.getTermsAndConditionsRequest()
                termsConditionsVC.dataSource = DataSource<TermsConditions>(
                    requestSender: AppDelegate.current().requestSender,
                    apiRequest: request
                )
            }
        }
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

//
//  SettingsViewController.swift
//  KneetlyUsers
//
//  Created by Matt Westcott on 20/9/16.
//  Copyright © 2016 Be IT Safe Pty Ltd. All rights reserved.
//

import UIKit
import KneetlyCommon

class SettingsViewController: MoreViewController {
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch segue.identifier ?? "" {
        case R.segue.settingsViewController.toFAQ.identifier:
            if let FAQVC = segue.destination as? FAQViewController {
                let request = ApiEndpoints.FAQs.getFAQsRequest()
                FAQVC.dataSource = DataSource<[FAQ]>(
                    requestSender: AppDelegate.current().requestSender,
                    apiRequest: request
                )
            }
        case R.segue.settingsViewController.toTermsConditions.identifier:
            if let termsConditionsVC = segue.destination as? TermsConditionsViewController {
                let request = ApiEndpoints.TermsAndConditions.getTermsAndConditionsRequest()
                termsConditionsVC.dataSource = DataSource<TermsConditions>(
                    requestSender: AppDelegate.current().requestSender,
                    apiRequest: request
                )
            }
        case R.segue.settingsViewController.toHelp.identifier:
            if let helpVC = segue.destination as? HelpViewController {
                helpVC.sender = .user
            }
        case R.segue.settingsViewController.toBadges.identifier:
            if let badgesVC = segue.destination as? BadgesViewController {
                let request = ApiEndpoints.Badges.getBadges()
                badgesVC.dataSource = DataSource<[Badge]>(
                    requestSender: AppDelegate.current().requestSender,
                    apiRequest: request
                )
            }
        case R.segue.settingsViewController.toReferral.identifier:
            if let referralVC = segue.destination as? ReferralViewController {
                referralVC.dataSource = DataSource<ReferralCode>(
                    requestSender: AppDelegate.current().requestSender,
                    apiRequest: ApiEndpoints.ReferralRequest.getLink()
                )
            }
        case R.segue.settingsViewController.toTutorials.identifier:
            if let tutorialsVC = segue.destination as? TutorialsViewController {
                let dataSource = DataSource(requestSender: AppDelegate.current().requestSender, apiRequest: ApiEndpoints.Video.tutorialRequest())
                tutorialsVC.tutorialsDataSource = dataSource
            }
        default: break
        }
    }
}

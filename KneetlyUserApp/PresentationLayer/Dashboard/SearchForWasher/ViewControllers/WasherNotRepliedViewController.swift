//
//  WasherNotRepliedViewController.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 14/02/2017.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit

class WasherNotRepliedViewController: NoWasherSearchResultViewController {
    
    @IBAction func keepWaiting() {
        let dashboardVC = R.storyboard.booking.instantiateInitialViewController()!
        if let tabbar = self.tabBarController as? TabBarController {
            tabbar.show(vc: dashboardVC, tabIndex: .dashboard)
        }
    }
}

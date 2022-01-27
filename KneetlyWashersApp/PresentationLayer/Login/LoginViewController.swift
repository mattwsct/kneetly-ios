//
//  LoginViewController.swift
//  KneetlyWashersApp
//
//  Created by Matt Westcott on 1/10/17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import KneetlyCommon

class LoginViewController: BaseLoginViewController {

    override func showMainVC() {
        AppDelegate.current().showMainScreen()
    }
    
    override func show(screen: ScreenType) {
        AppDelegate.current().showMainScreen()
    }
}


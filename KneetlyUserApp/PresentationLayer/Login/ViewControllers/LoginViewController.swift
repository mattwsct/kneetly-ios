//
//  Created by Suresh.
//  Copyright © 2016 Be IT Safe Pty Ltd. All rights reserved.
//

import UIKit
import KneetlyCommon
import Firebase
import GoogleSignIn

class LoginViewController: BaseLoginViewController {
    
    override func showMainVC() {
        AppDelegate.current().showMainScreen()
    }

    override func show(screen: ScreenType) {
        switch screen {
        case .dashboard, .unknown:
            AppDelegate.current().showMainScreen()
            break
        case .updateProfile, .addVehicle, .addCardInfo, .credentials:
            self.showRegister(screenType: screen)
        }
    }
    
    func showRegister(screenType: ScreenType) {
        let nextViewController = R.storyboard.login().instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        nextViewController.setFirstScreen(screen: screenType)
        self.present(nextViewController, animated:true, completion:nil)
    }
}

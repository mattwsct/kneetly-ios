//
//  AppAccessViewController.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 2/22/17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import KneetlyCommon

class AppAccessViewController: UIViewController {

}


extension AppAccessViewController: NavigationRequestHandler {
    
    func handle(navigationRequest: NavigationRequest, completion: () -> ()) {
        guard let request = navigationRequest.toUserAppNavigationRequest() else {
            return
        }
        
        let vc = R.storyboard.login.registerViewController()!
                
        switch request.screen {
        case .registration(let screen):
            let type: ScreenType
            switch screen {
            case .addCardInformation, .termsAndConditions:
                type = .addCardInfo
            case .profileSetup:
                type = .updateProfile
            case .registerCar:
                type = .addVehicle
            case .credentials:
                type = .credentials
            }
            
            vc.setFirstScreen(screen: type)
            self.present(vc, animated:true, completion:nil)
            
        default:
            break
        }
        
        
    }
}
 

//
//  File.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 05.12.16.
//  Copyright © 2016 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import KneetlyCommon
import SnapKit

// FIXME: Rename RegisterVehiclesViewController and RegisterVehicleViewController to resolve ambiguity.
class RegisterVehiclesViewController: UIViewController, WizardPage {

    // MARK: WizardPage
    var vehiclesViewController : RegisterVehicleViewController = R.storyboard.vehicles.registerVehicleViewController()!
    
    override func loadView() {
        super.loadView()
        
        self.vehiclesViewController = R.storyboard.vehicles.registerVehicleViewController()!
        self.vehiclesViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        self.addChildViewController(self.vehiclesViewController)
        self.view.addSubview(self.vehiclesViewController.view)
        self.vehiclesViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.vehiclesViewController.didMove(toParentViewController: self)
        
        self.vehiclesViewController.didAddVehicle = {
            self.wizardController()?.showNext()
        }
    }
    
    func nextButtonDidPressed() -> Bool {
        return self.vehiclesViewController.nextButtonDidPressed()
    }
    
    func isHeaderButtonEnabled(index: Int) -> Bool {
        return false
    }
}

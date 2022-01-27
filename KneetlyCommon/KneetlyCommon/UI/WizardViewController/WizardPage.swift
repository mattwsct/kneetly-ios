//
//  WizardPage.swift
//  KneetlyUsers
//
//  Created by Matt Westcott on 24.11.16.
//  Copyright © 2016 Be IT Safe Pty Ltd. All rights reserved.
//

import UIKit

public protocol WizardPage {
    var pageView: UIView { get }
    var pageViewController: UIViewController? { get }
    
    func pageTitle() -> String?
    func nextButtonTitle() -> String
    
    func shouldShowCancelButton() -> Bool
    
    func isHeaderButtonEnabled(index: Int) -> Bool
    
    func willMoveToPage(index: Int)
    func didMoveToPage(fromIndex: Int)
    
    func nextButtonDidPressed() -> Bool
}

public extension WizardPage {
    func pageTitle() -> String? {
        return nil
    }
    
    func nextButtonTitle() -> String {
        return R.string.localized.wizardViewControllerNextStep()
    }
    
    func nextButtonDidPressed() -> Bool {
        self.wizardController()?.showNext()
        return true
    }
    
    func shouldShowCancelButton() -> Bool {
        return false
    }
    
    func isHeaderButtonEnabled(index: Int) -> Bool {
        return true
    }
    
    func willMoveToPage(index: Int) {
        
    }
    
    func didMoveToPage(fromIndex: Int) {
        
    }
}

public extension WizardPage {
    func wizardController() -> WizardViewController? {
        return self.pageViewController?.parent as? WizardViewController
    }
}

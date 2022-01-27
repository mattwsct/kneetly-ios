//
//  KneetyWizardViewController.swift
//  KneetlyUsers
//
//  Created by Matt Westcott on 24.11.16.
//  Copyright © 2016 Be IT Safe Pty Ltd. All rights reserved.
//

import UIKit
import SnapKit

public protocol WizardViewControllerDelegate: class {
    func wizardDidCanceled(wizard: WizardViewController)
    func wizardDidFinished(wizard: WizardViewController)
}

open class WizardViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var headerView: WizardHeaderView!
    @IBOutlet weak var nextButton: KneetlyButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var transitionDuration: TimeInterval = 0.2
    
    public weak var wizardDelegate: WizardViewControllerDelegate?
    public var firstPageIndex : Int = 0
    public var pages: [WizardPage] = [] {
        didSet {
            headerView.reloadData()
            showDefaultPage()
        }
    }
    
    public private(set) var  currentIndex: Int = -1
    
    var currentPage: WizardPage? {
        return pages[safe: currentIndex]
    }
    
    override open func loadView() {
        self.view = R.nib.wizardViewController.firstView(owner: self)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        headerView.delegate = self
        headerView.selectedItem = currentIndex
        headerView.reloadData()
        showDefaultPage()
    }
    
    @discardableResult
    public func showNext() -> Bool {
        if currentIndex == pages.count - 1 {
            wizardDelegate?.wizardDidFinished(wizard: self)
            return false
        } else {
            return showPage(index: currentIndex + 1)
        }
    }
    
    @discardableResult
    public func showPrevious() -> Bool {
        return showPage(index: currentIndex - 1)
    }
    
    @discardableResult
    public func showPage(index:Int) -> Bool {
        guard let page = pages[safe: index] else { return false }
        guard index != currentIndex else { return false }
        let fromIndex = currentIndex
        
        let viewController = pages[safe: index]?.pageViewController
        
        viewController?.willMove(toParentViewController: self)
        
        if let viewController = viewController {
            self.addChildViewController(viewController)
        }
        
        if currentPage?.pageView != nil {
            updateInterfaceForPage(index: index)
            page.willMoveToPage(index: index)
            animateTransition(fromPage: fromIndex, toPage: index) { animated in
                self.finishTransition(fromPage: fromIndex, toPage: index, animated: animated)
                page.didMoveToPage(fromIndex: fromIndex)
            }
        } else {
            page.willMoveToPage(index: index)
            page.pageView.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(page.pageView)
            
            self.contentView.snp.makeConstraints({ make in
                make.edges.equalTo(page.pageView)
            })
            
            updateInterfaceForPage(index: index)
            finishTransition(fromPage: fromIndex, toPage: index, animated: false)
            page.didMoveToPage(fromIndex: fromIndex)
        }
        
        return true
    }
    
    func updateInterface() {
        self.updateInterfaceForPage(index: currentIndex)
    }
    
    private func showDefaultPage() {
        showPage(index: self.firstPageIndex)
    }
    
    private func updateInterfaceForPage(index:Int) {
        let page = pages[index]
        
        let title = page.nextButtonTitle()
        self.nextButton.setTitle(title, for: .normal)
        
        let showCancelButton = page.shouldShowCancelButton()
        self.cancelButton.isEnabled = showCancelButton
        self.cancelButton.isHidden = !showCancelButton
        
        for (buttonIndex, button) in headerView.buttons.enumerated() {
            button.isEnabled = page.isHeaderButtonEnabled(index: buttonIndex) || buttonIndex == index
        }
        
        self.headerView.selectedItem = index
    }
    
    private func animateTransition(fromPage sourceIndex:Int, toPage destinationIndex:Int, completion: @escaping (Bool) -> Void) {
        let sourcePage = pages[sourceIndex]
        let destinationPage = pages[destinationIndex]
        
        destinationPage.pageView.translatesAutoresizingMaskIntoConstraints = false
        destinationPage.pageView.alpha = 0.0
        
        contentView.addSubview(destinationPage.pageView)
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(destinationPage.pageView)
        }
        
        UIView.animate(withDuration: transitionDuration, animations: { 
            destinationPage.pageView.alpha = 1.0
        }, completion: { finished in
            sourcePage.pageView.removeFromSuperview()
            completion(finished)
        })
        
        updateInterfaceForPage(index: destinationIndex)
    }
    
    private func finishTransition(fromPage sourceIndex:Int, toPage destinationIndex:Int, animated:Bool) {
        
        let sourcePage = pages[safe: sourceIndex]
        let destinationPage = pages[destinationIndex]
        
        sourcePage?.pageView.removeFromSuperview()
        sourcePage?.pageViewController?.removeFromParentViewController()
        destinationPage.pageViewController?.didMove(toParentViewController: self)
        self.currentIndex = destinationIndex
    }
    
    @IBAction private func nextButtonDidPressed() {
        if let currentPage = currentPage {
            currentPage.nextButtonDidPressed()
        }
    }
    
    @IBAction func cancelButtonDidPressed() {
        wizardDelegate?.wizardDidCanceled(wizard: self)
    }
}

extension WizardViewController: WizardHeaderViewDelegate {
    func countOfItemsInWizardHeader(_ wizardHeaderView: WizardHeaderView) -> Int {
        return pages.count
    }
    
    func wizardHeader(_ wizardHeaderView: WizardHeaderView, titleForItemWithIndex index: Int) -> String? {
        let page = pages[index]
        return page.pageTitle() ?? page.pageViewController?.title
    }
    
    func wizardHeader(_ wizardHeaderView: WizardHeaderView, didSelectItemWithIndex index: Int) -> Bool {
        return self.showPage(index: index)
    }
}

//
//  PaymentMethodViewController.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 31/01/2017.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import KneetlyCommon
import Stripe

class PaymentMethodViewController: UIViewController {

    var personalPaymentContext: STPPaymentContext!
    var businessPaymentContext: STPPaymentContext?
    
    var businessId: String? {
        didSet {
            guard let businessId = businessId else {
                businessPaymentContext = nil
                return
            }
            
            setupBusinessPaymentContext(forBusinessId: businessId)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupPersonalPaymentContext()
    }
    
    private func setupBusinessPaymentContext(forBusinessId id: String) {
        businessPaymentContext = STPPaymentContext(apiAdapter: StripeBackendAPIAdapter(requestSender: AppDelegate.current().requestSender, businessId: id))
        
        businessPaymentContext!.hostViewController = self
        businessPaymentContext!.delegate = self
        businessPaymentContext!.retryLoading()
    }
    
    private func setupPersonalPaymentContext() {
        personalPaymentContext = STPPaymentContext(apiAdapter: StripeBackendAPIAdapter(requestSender: AppDelegate.current().requestSender))
        personalPaymentContext.hostViewController = self
        personalPaymentContext.delegate = self
        personalPaymentContext.retryLoading()
        
        AuthentificationManager.sharedInstance.currentEmail(completion: { [weak self] email in
            let userInformation = STPUserInformation()
            userInformation.email = email
            self?.personalPaymentContext.prefilledInformation = userInformation
        })
        
    }
    
    func presentPaymentMethodsViewController(forBusinessId: String?) {
        if let _ = forBusinessId {
            guard let businessPaymentContext = businessPaymentContext else {
                return
            }
            
            businessPaymentContext.presentPaymentMethodsViewController()
        }
        else {
            personalPaymentContext.presentPaymentMethodsViewController()
        }
    }
    
    func didReceivePaymentMethodsNames(_: [String], forBusinessId: String?) {
    }
    
    func didReceiveSelectedPaymentMethodName(_: String, image: UIImage, forBusinessId: String?) {
    }
}

extension PaymentMethodViewController: STPPaymentContextDelegate {
    
    public func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        KneetlyAlert.show(errorMessage: R.string.localized.commonLoadDataErrorUnknown(), buttonTitle: R.string.localized.commonRetry()) {
            paymentContext.retryLoading()
        }
    }
    
    public func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        if let paymentMethods = paymentContext.paymentMethods {
            didReceivePaymentMethodsNames(paymentMethods.map({ return $0.label }), forBusinessId: paymentContext == businessPaymentContext ? businessId : nil)
        }
        
        if let paymentMethod = paymentContext.selectedPaymentMethod {
            didReceiveSelectedPaymentMethodName(paymentMethod.label, image: paymentMethod.image, forBusinessId: paymentContext == businessPaymentContext ? businessId : nil)
        }
    }
    
    public func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
        
    }
    
    public func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?){
        
    }
}

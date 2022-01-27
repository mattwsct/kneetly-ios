//
//  TermsConditionsViewController.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 26.01.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit

open class TermsConditionsViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var textViewConstant: NSLayoutConstraint!
    
    open var dataSource: DataSource<TermsConditions>?
    
    // MARK: - View controller lifecycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()

        reloadData()
    }
    
    // MARK: - Helpers
    
    private func reloadData() {
        showProgress()
        dataSource?.reload { [unowned self] in
            self.hideProgress()
            self.updateContent(text: self.dataSource?.object?.description ?? "")
        }
    }
    
    private func updateContent(text: String) {
        self.webView.loadHTMLString(text, baseURL: nil)
    }
}

extension TermsConditionsViewController: UIWebViewDelegate {
    
    public func webViewDidFinishLoad(_ webView: UIWebView) {
        webView.frame.size.height = 1
        textViewConstant.constant = webView.sizeThatFits(CGSize.zero).height
        self.view.updateConstraintsIfNeeded()
    }
}

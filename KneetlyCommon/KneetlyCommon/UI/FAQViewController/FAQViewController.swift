//
//  FAQViewController.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 24.01.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit

open class FAQViewController: UIViewController {
    
    enum FAQContent: Int {
        case question, answer
        
        static func countExpanded() -> Int {
            return 2
        }
        
        static func countCollapsed() -> Int {
            return 1
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    open var dataSource: DataSource<[FAQ]>?
    
    fileprivate var faqs: [FAQ] {
        get {
            return dataSource?.items ?? []
        }
    }
    
    // MARK: - View controller lifecycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 45
        tableView.rowHeight = UITableViewAutomaticDimension
        
        reloadData()
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutFooterIfNeeded()
    }
    
    // MARK: - Helpers
    
    private func reloadData() {
        showProgress()
        dataSource?.reload { [unowned self] in
            self.hideProgress()
            self.tableView?.reloadData()
            self.layoutFooterIfNeeded()
        }
    }
    
    private func layoutFooterIfNeeded() {
        DispatchQueue.main.async {
            if let footerView = self.tableView.tableFooterView {
                var fvFrame = footerView.frame
                if (fvFrame.maxY < self.tableView.frame.maxY) {
                    fvFrame.origin.y = self.tableView.frame.maxY - fvFrame.height
                    footerView.frame = fvFrame
                }
            }
        }
    }
}

extension FAQViewController: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return faqs.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqs[section].expanded ? FAQContent.countExpanded() : FAQContent.countCollapsed()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        let faqItem = faqs[indexPath.section]
        if let faqContent = FAQContent(rawValue: indexPath.row) {
            switch faqContent {
            case .question:
                cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.fAQQuestionCell)!
            case .answer:
                cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.fAQAnswerCell)!
            }
            (cell as! FAQCell).configure(faq: faqItem)
        }
        return cell!
    }
}

extension FAQViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let faqContent = FAQContent(rawValue: indexPath.row), faqContent == .question {
            let faqItem = faqs[indexPath.section]
            faqItem.expanded = !faqItem.expanded
            tableView.reloadSections(IndexSet(integer: indexPath.section), with: .none)
        }
    }
}

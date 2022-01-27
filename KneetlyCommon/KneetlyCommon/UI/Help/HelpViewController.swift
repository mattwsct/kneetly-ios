//
//  HelpViewController.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 27.01.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import KneetlyCommon
import ActionSheetPicker_3_0
import KMPlaceholderTextView

public enum HelpRequestSender: String {
    case user = "users"
    case washer = "washer"
}

open class HelpViewController: UIViewController, CallSupport {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var commentsTextView: KMPlaceholderTextView!
    @IBOutlet weak var submitButton: KneetlyButton!
    
    open var sender: HelpRequestSender! // TODO: Should be received from previous screen
    
    private var categories: [ProblemCategory] = [] {
        didSet {
            if (category == nil) {
                category = categories.first
            }
        }
    }
    private var category: ProblemCategory? {
        didSet {
            categoryLabel.text = category?.name ?? ""
        }
    }
    
    private lazy var categoryPicker: ActionSheetStringPicker = { [unowned self] in
        return self.stringPickerWithRows(
            rows: self.categories.map { $0.name },
            selectedRow: self.category?.name ?? "",
            doneBlock: { [unowned self] value in
                if let selectedIndex = self.categories.index(where: { $0.name == value }) {
                    self.category = self.categories[selectedIndex]
                }
            },
            origin: self.categoryLabel)
        }()
    
    // MARK: - View controller lifecycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.commentsTextView.delegate = self
        self.submitButton.setEnabled(isEnabled: false)
        getCategories()
    }
    
    // MARK: - Actions
    
    @IBAction func showCategories(_ sender: UITapGestureRecognizer) {
        categoryPicker.show()
    }
    
    @IBAction func submit() {
        submitHelpRequest()
    }
    
    @IBAction func callSupport(_ sender: Any) {
        callSupport()
    }
    
    // MARK: - Helpers
    
    private func stringPickerWithRows(rows: [String], selectedRow: String, doneBlock: @escaping (String) -> Void, origin: Any) -> ActionSheetStringPicker {
        return ActionSheetStringPicker(
            title: "",
            rows: rows,
            initialSelection: rows.index(of: selectedRow) ?? 0,
            doneBlock: { picker, index, value in
                doneBlock((value as? String) ?? "")
                return
            },
            cancel: nil,
            origin: origin
        )
    }
    
    private func getCategories() {
        showProgress()
        
        let getCategoriesRequest = ApiEndpoints.Help.getCategoriesRequest(consumer: sender.rawValue)
        BaseAppDelegate.current().requestSender.sendRequest(
            apiRequest: getCategoriesRequest,
            completion: { result in
                self.hideProgress()
                switch result {
                case .success(let categories):
                    self.categories = categories
                case .failure(let error):
                    KneetlyAlert.show(errorMessage: error.message ?? "")
                }
            }
        )
    }
    
    private func submitHelpRequest() {
        showProgress()
    
        let helpSubmitRequest = ApiEndpoints.Help.helpSubmitRequest(
            consumer: sender.rawValue,
            categoryId: category?.id ?? "",
            comments: commentsTextView.text
        )
        BaseAppDelegate.current().requestSender.sendRequest(
            apiRequest: helpSubmitRequest,
            completion: { result in
                self.hideProgress()
                switch result {
                case .success(_):
                    self.navigateBackAnimated()
                case .failure(let error):
                    KneetlyAlert.show(errorMessage: error.message ?? "")
                }
            }
        )
    }
}

extension HelpViewController: UITextViewDelegate {
    
    public func textViewDidChange(_ textView: UITextView) {
        self.submitButton.setEnabled(isEnabled: textView.hasText == true)
    }
}

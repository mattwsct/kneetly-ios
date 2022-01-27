//
//  ProblemViewController.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 23.01.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import KneetlyCommon
import ActionSheetPicker_3_0
import KMPlaceholderTextView

public enum ProblemReportSender: String {
    case user = "users"
    case washer = "washer"
}

open class ProblemViewController: UIViewController, CallSupport {
    
    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet weak var commentsTextView: KMPlaceholderTextView!
    @IBOutlet weak var submitButton: KneetlyButton!
    
    open var sender: ProblemReportSender! // TODO: Should be received from previous screen
    open var bookingsId: String = "" // TODO: Should be received from previous screen
    
    private var reasons: [ProblemCategory] = [] {
        didSet {
            if (reason == nil) {
                reason = reasons.first
            }
        }
    }
    private var reason: ProblemCategory? {
        didSet {
            reasonLabel.text = reason?.name ?? ""
        }
    }
    
    private lazy var reasonPicker: ActionSheetStringPicker = { [unowned self] in
        return self.stringPickerWithRows(
            rows: self.reasons.map { $0.name },
            selectedRow: self.reason?.name ?? "",
            doneBlock: { [unowned self] value in
                if let selectedIndex = self.reasons.index(where: { $0.name == value }) {
                    self.reason = self.reasons[selectedIndex]
                }
            },
            origin: self.reasonLabel)
    }()
    
    // MARK: - View controller lifecycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.commentsTextView.delegate = self
        self.submitButton.setEnabled(isEnabled: false)
        getReasons()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Actions
    
    @IBAction func showReasons(_ sender: Any) {
        reasonPicker.show()
    }
    
    @IBAction func submit() {
        submitProblem()
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
    
    private func getReasons() {
        showProgress()
        
        let getCategoriesRequest = ApiEndpoints.Problem.getCategoriesRequest(consumer: sender.rawValue)
        BaseAppDelegate.current().requestSender.sendRequest(
            apiRequest: getCategoriesRequest,
            completion: { result in
                self.hideProgress()
                switch result {
                case .success(let reasons):
                    self.reasons = reasons
                case .failure(let error):
                    KneetlyAlert.show(errorMessage: error.message ?? "")
                }
            }
        )
    }
    
    private func submitProblem() {
        showProgress()
        let request = ApiEndpoints.Problem.reportProblemRequest(
            consumer: sender.rawValue,
            bookingsId: bookingsId,
            description: commentsTextView.text,
            category: reason!.id
        )
        BaseAppDelegate.current().requestSender.sendRequest(
            apiRequest: request,
            completion: { result in
                self.hideProgress()
                switch result {
                case .success( _):
                    self.navigateBackAnimated()
                case .failure(let error):
                    KneetlyAlert.show(errorMessage: error.message ?? "")
                }
            }
        )
    }
}

extension ProblemViewController: UITextViewDelegate {
    
    public func textViewDidChange(_ textView: UITextView) {
        self.submitButton.setEnabled(isEnabled: textView.hasText == true)
    }
}


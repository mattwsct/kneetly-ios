//
//  ReviewUserViewController.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 18.01.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import HCSStarRatingView
import KMPlaceholderTextView

public enum ReviewSender: String {
    case user = "users"
    case washer = "washer"
}

open class ReviewViewController: UIViewController {
    
    @IBOutlet open weak var ratingView: HCSStarRatingView!
    @IBOutlet open weak var favoriteView: UIView!
    @IBOutlet open weak var favoriteSwitch: UISwitch!
    @IBOutlet open weak var commentsTextView: KMPlaceholderTextView!
    
    open var sender: ReviewSender!
    open var bookingsId: String = ""
    open var washerId: String = ""
    
    // MARK: - Actions
    
    @IBAction open func confirm() {
        confirmReview()
    }
    
    open override func viewDidLoad() {
        favoriteView.isHidden = sender == .washer
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Helpers
    
    private func confirmReview() {
        let rating = Int(ratingView.value)
        guard rating > 0 else {
            KneetlyAlert.show(errorMessage: R.string.localized.reviewChooseRatingErrorText())
            return
        }
        
        showProgress()
        let confirmReviewRequest = ApiEndpoints.Rating.addRequest(sender: sender, bookingsId: bookingsId, rating: rating, comments: commentsTextView.text ?? "")
        BaseAppDelegate.current().requestSender!.sendRequest(
            apiRequest: confirmReviewRequest,
            completion: { result in
                self.hideProgress()
                switch result {
                case .success( _):
                    switch self.sender! {
                    case .user:
                        if self.favoriteSwitch.isOn {
                            self.addFavorite() {
                                self.navigateToRootAnimated()
                            }
                        } else {
                            self.navigateToRootAnimated()
                        }
                    case .washer:
                        NotificationCenter.default.post(name: NSNotification.Name.Navigation.navigateToLookingForUser, object: nil)
                    }
                case .failure(let error):
                    KneetlyAlert.show(errorMessage: error.message ?? "")
                }
            }
        )
    }
    
    private func addFavorite(completion: @escaping () -> Void) {
        showProgress()
        let favoriteRequest = ApiEndpoints.UserFavouriteRequest.add(washerId: washerId)
        BaseAppDelegate.current().requestSender!.sendRequest(
            apiRequest: favoriteRequest,
            completion: { result in
                self.hideProgress()
                completion()
            }
        )
    }
}

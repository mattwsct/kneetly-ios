//
//  TabbarViewController.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 2/1/17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import KneetlyCommon

class TabBarController: UITabBarController {

    enum TabIndex: Int {
        case dashboard = 0, vehicles = 1, history = 2, more = 3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
}

extension TabBarController: NavigationRequestHandler {
    func handle(navigationRequest: NavigationRequest, completion: () -> ()) {
        guard let request = navigationRequest.toUserAppNavigationRequest() else {
            return
        }
        
        switch request.screen {
        case .wash(let washScreen):
            show(washScreen: washScreen)
        case .badge(let badgeScreen):
            showBadgeScreen(badgeScreen)
        default:
            break
        }
    }
    
    private func show(washScreen: WashScreen) {
        switch washScreen {
        case .washerFound(let bookingId, let washerID):
            let vc = R.storyboard.searchForWasher.washerFoundViewController()!
            vc.bookingId = bookingId
            vc.washerId = washerID
            show(vc: vc, tabIndex: TabIndex.dashboard)
        case .noWasherFound(let bookingId):
            let vc = R.storyboard.searchForWasher.noWasherFoundViewController()!
            vc.bookingId = bookingId
            show(vc: vc, tabIndex: TabIndex.dashboard)
        case .washerNoAvailable(let bookingId):
            let vc = R.storyboard.searchForWasher.washerUnavailableViewController()!
            vc.bookingId = bookingId
            show(vc: vc, tabIndex: TabIndex.dashboard)
        case .washerNotReplied(let bookingId):
            let vc = R.storyboard.searchForWasher.washerNotRepliedViewController()!
            vc.bookingId = bookingId
            show(vc: vc, tabIndex: TabIndex.dashboard)
        case .washCompleted(let bookingId):
            let vc = R.storyboard.wash.completeWashViewController()!
            vc.bookingId = bookingId
            show(vc: vc, tabIndex: TabIndex.dashboard)
        case .washInProgress(let bookingId):
            let vc = R.storyboard.wash.washInProgressViewController()!
            vc.configure(bookingId: bookingId)
            show(vc: vc, tabIndex: TabIndex.dashboard)
        case .washerArrived(let bookingId):
            let storyboard = UIStoryboard(name: R.string.localized.storyboardDamages(), bundle: Bundle(identifier: R.string.localized.bundleCommon()))
            let vc  = storyboard.instantiateInitialViewController() as! PreWashChecklistViewController
            vc.configure(targetType: .user, bookingId: bookingId, state: .waitingForWasher)
            show(vc: vc, tabIndex: TabIndex.dashboard)
        case .washerAddedDamages(let bookingId):
            let storyboard = UIStoryboard(name: R.string.localized.storyboardDamages(), bundle: Bundle(identifier: R.string.localized.bundleCommon()))
            let vc  = storyboard.instantiateInitialViewController() as! PreWashChecklistViewController
            vc.configure(targetType: .user, bookingId: bookingId, state: .userConfirm)
            show(vc: vc, tabIndex: TabIndex.dashboard)
        case .cancelBooking(let bookingId, let vehicleId, let washerId):
            _ = resetAndShowTab(atIndex: TabIndex.dashboard.rawValue)
            showPushNotificationPopup(withMessage: R.string.localized.bookingCanceledMessage())
            showInterviewScreen(withBookingId: bookingId, vehicleId: vehicleId, washerId: washerId)
        case .dashboard:
            _ = resetAndShowTab(atIndex: TabIndex.dashboard.rawValue)
        case .confirmBooking(let bookingId, let vehicleId):
            let vc = R.storyboard.booking.confirmBookingViewController()!
            vc.bookingId = bookingId
            vc.vehicleId = vehicleId
            show(vc: vc, tabIndex: TabIndex.dashboard)
        case .searchForWasher(let bookingId):
            let vc = R.storyboard.searchForWasher.searchForWasherViewController()!
            vc.bookingId = bookingId
            show(vc: vc, tabIndex: TabIndex.dashboard)
        case .washerIsWaiting(let bookingId, let userId, let washerId):
            let vc = WasherIncomingOrWaitingViewController.vc(withBookingId: bookingId, washerId: washerId, userId: userId)
            show(vc: vc, tabIndex: TabIndex.dashboard)
        case .reviewWasher(let bookingId, let washerId):
            let bundle = Bundle(identifier: "com.beitsafe.KneetlyCommon")
            let sb = UIStoryboard(name: "Review", bundle: bundle)
            let vc = sb.instantiateInitialViewController() as! ReviewViewController
            vc.sender = .user
            vc.bookingsId = bookingId
            vc.washerId = washerId
            show(vc: vc, tabIndex: TabIndex.dashboard)
        case .paymentDeclined(let bookingId, let vehicleId):
            let vc = R.storyboard.booking.confirmBookingViewController()!
            vc.bookingId = bookingId
            vc.vehicleId = vehicleId
            show(vc: vc, tabIndex: TabIndex.dashboard)
            showPushNotificationPopup(withMessage: R.string.localized.paymentDeclinedMessage())
        }
    }
    
    private func showInterviewScreen(withBookingId bookingId: String, vehicleId: String, washerId: String) {
        showProgress()
        
        let request = ApiEndpoints.Booking.getBooking(id: bookingId)
        BaseAppDelegate.current().requestSender.sendRequest(apiRequest: request) { (result) in
            self.hideProgress()
            
            guard let booking = result.value else {
                return
            }
            
            let wash = Wash()
            wash.washerId = washerId
            wash.vehicleId = vehicleId
            wash.vehicleNickname = booking.vehicleNickname
            wash.washTypeId = booking.washtypeId
            wash.washTypeName = booking.washTypeName ?? ""
            let vc = R.storyboard.booking.interviewViewController()!
            vc.planningWash = wash
            
            self.show(vc: vc, tabIndex: TabIndex.dashboard)
            
        }
    }
    
    public func show(vc: UIViewController, tabIndex: TabIndex) {
        guard resetAndShowTab(atIndex: tabIndex.rawValue) else {
            return
        }
        
        navigationController(forTabIndex: tabIndex.rawValue)?.pushViewController(vc, animated: true)
    }
    
}

extension TabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return viewController != tabBarController.selectedViewController
    }
}

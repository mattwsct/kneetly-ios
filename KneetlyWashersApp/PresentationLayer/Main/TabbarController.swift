//
//  TabbarController.swift
//  KneetlyWashersApp
//
//  Created by Matt Westcott on 2/3/17.
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
        guard let request = navigationRequest.toWasherAppNavigationRequest() else {
            return
        }
        
        switch request.screen {
        case .wash(let washScreen):
            show(washScreen: washScreen)
        case .badge(let badgeScreen):
            showBadgeScreen(badgeScreen)
        case .login(let loginScreen):
            switch loginScreen {
            case .mandatoryVideo:
                showMandatoryVideoScreen()
            }
            break
        }
    }
    
    private func show(washScreen: WashScreen) {
        switch washScreen {
        case .jobFound(let bookingId, let userId):
            let vc = R.storyboard.dashboard.jobFoundViewController()!
            vc.bookingId = bookingId
            vc.userId = userId
            show(vc: vc, tabIndex: TabIndex.dashboard)
        case .userAcceptsJob(let bookingId, let userId, let washerId):
            let vc = UserIncomingOrWaitingViewController.vc(withBookingId: bookingId, washerId: washerId, userId: userId)
            show(vc: vc, tabIndex: TabIndex.dashboard)
        case .userCancelWash:
            show(vc: R.storyboard.dashboard().instantiateViewController(withIdentifier: R.storyboard.dashboard.lookingForUserViewController.identifier), tabIndex: .dashboard)
            showPushNotificationPopup(withMessage: R.string.localized.washCanceledMessage())
        case .userConfirmedDamages(let bookingId):
            let vc = R.storyboard.washProcess.instantiateInitialViewController()!
            vc.configure(bookingId: bookingId)
            show(vc: vc, tabIndex: TabIndex.dashboard)
        case .dashboard:
            _ = resetAndShowTab(atIndex: TabIndex.dashboard.rawValue)
        case .lookingForUser:
            let vc = R.storyboard.dashboard.lookingForUserViewController()!
            show(vc: vc, tabIndex: TabIndex.dashboard)
        case .washInProgress(let bookingId):
            let vc = R.storyboard.washProcess.washInProgressViewController()!
            vc.bookingId = bookingId
            show(vc: vc, tabIndex: TabIndex.dashboard)
        case .reviewUser(let bookingId, let washerId):
            let bundle = Bundle(identifier: "com.beitsafe.KneetlyCommon")
            let sb = UIStoryboard(name: "Review", bundle: bundle)
            let vc = sb.instantiateInitialViewController() as! ReviewViewController
            vc.sender = .washer
            vc.bookingsId = bookingId
            vc.washerId = washerId
            show(vc: vc, tabIndex: TabIndex.dashboard)
        case .washerSubmitsDamagesAndWaitingForApproval(let bookingId):
            let storyboard = UIStoryboard(name: "PreWashChecklist", bundle: Bundle(identifier: "com.beitsafe.KneetlyCommon"))
            let vc  = storyboard.instantiateInitialViewController() as! PreWashChecklistViewController
            vc.configure(targetType: .washer, bookingId: bookingId, state: .waitingForClient)
            show(vc: vc, tabIndex: TabIndex.dashboard)
        case .userSubmitDamages(let bookingId):
            let storyboard = UIStoryboard(name: "PreWashChecklist", bundle: Bundle(identifier: "com.beitsafe.KneetlyCommon"))
            let vc  = storyboard.instantiateInitialViewController() as! PreWashChecklistViewController
            vc.configure(targetType: .washer, bookingId: bookingId, state: .washerSubmit)
            show(vc: vc, tabIndex: TabIndex.dashboard)
        case .userApprovedDamagesAddedByWasher(let bookingId):
            let storyboard = UIStoryboard(name: "PreWashChecklist", bundle: Bundle(identifier: "com.beitsafe.KneetlyCommon"))
            let vc  = storyboard.instantiateInitialViewController() as! PreWashChecklistViewController
            vc.configure(targetType: .washer, bookingId: bookingId, state: .startWash)
            show(vc: vc, tabIndex: TabIndex.dashboard)
        }
    }
    
    public func show(vc: UIViewController, tabIndex: TabIndex) {
        guard let nc = viewControllers?[tabIndex.rawValue] as? UINavigationController else {
            return
        }
        
        selectedViewController = nc
        
        nc.popToRootViewController(animated: false)
        nc.pushViewController(vc, animated: true)
    }
    
    private func showMandatoryVideoScreen() {
        let requestSender = BaseAppDelegate.current().requestSender!
        func showUnwatchedVideoScreen(withDataSource ds: DataSource<[VideoItem]>) -> TutorialsViewController {
            let bundle = Bundle(identifier: "com.beitsafe.KneetlyCommon")
            let sb = UIStoryboard(name: "Tutorials", bundle: bundle)
            let vc = sb.instantiateInitialViewController() as! TutorialsViewController
            vc.tutorialsDataSource = ds
            vc.canUserControlVideo = false
            vc.watchedVideoTracker = WatchedVideoTracker(requestSender: requestSender, markAsWatchedRequestProvider: { (id) -> (ApiRequest<ApiObject, ApiErrorCategory<ApiDefaultError>>) in
                return ApiEndpoints.Video.markAsWathedRequest(videoId: id)
            })
            present(vc, animated: true, completion: nil)
            return vc
        }
        
        let request = ApiEndpoints.Video.unwatchedVideoRequest()
        let ds = DataSource(requestSender: requestSender, apiRequest: request)
        ds.reload {
            if ds.items != nil  && ds.items!.count > 0 {
                let vc = showUnwatchedVideoScreen(withDataSource: ds)
                vc.allVideoIsWatchedHandler = {
                     self.dismiss(animated: true, completion: nil)
                }
            }
            
        }
    }
}

extension TabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return viewController != tabBarController.selectedViewController
    }
}

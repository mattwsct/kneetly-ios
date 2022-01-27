//
//  PushNotification.swift
//  KneetlyWashersApp
//
//  Created by Matt Westcott on 2/3/17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import KneetlyCommon

class PushNotificatationParserProvider {
    
    static let parser: PushNotificationParser<WasherPushNotificationType> = {
        let result = PushNotificationParser<WasherPushNotificationType>()
        result.parseImpl = { (data, type) in
            return parseUserNotification(withData: data, category: type)
        }
        
        return result
    }()
    
    static func parseUserNotification(withData data: [String: Any], category: PushNotificationCategory) -> WasherPushNotificationType?  {
        switch category {
        case .washflow:
            guard let info = PushNotificationParser<WasherPushNotificationType>.parseWashflowNotification(data: data) else {
                return nil
            }
            return WasherPushNotificationType.washflow(info)
        case .badges:
            guard let info = PushNotificationParser<WasherPushNotificationType>.parseBadgeNotification(data: data) else {
                return nil
            }
            return WasherPushNotificationType.badges(info)
        default:
            return nil
        }
    }
}

enum WasherPushNotificationType: PushNotificationType {
    case washflow(WashflowInfoMessage)
    case badges(BadgeInfoMessage)
}

extension NavigationRequest {
    func toWasherAppNavigationRequest() -> WasherAppNavigationRequest? {
        guard let category = self.screen as? WasherAppScreenCategory else {
            return nil
        }
        
        return WasherAppNavigationRequest(screen: category, info: self.info)
    }
}

public struct WasherAppNavigationRequest {
    let screen: WasherAppScreenCategory
    let info: [String: Any]?
}

enum WasherAppScreenCategory: ScreenCategory {
    case wash(WashScreen)
    case badge(BadgeScreen)
    case login(LoginScreen)
    
    var requiredScreenPresenter: ScreenRequiredPresenter {
        return .mainScreen
    }
}

enum WashScreen {
    case jobFound(bookingId: String , userId: String)
    case userAcceptsJob(bookingId: String , userId: String, washerId: String)
    case userSubmitDamages(bookingId: String)
    case userConfirmedDamages(bookingId: String)
    case washInProgress(bookingId: String)
    case userCancelWash
    case dashboard
    case lookingForUser
    case reviewUser(bookingId: String, washerId: String)
    case userApprovedDamagesAddedByWasher(bookingId: String)
    case washerSubmitsDamagesAndWaitingForApproval(bookingId: String)
}

enum LoginScreen {
    case mandatoryVideo
}

protocol WasherAppNavigationRequestHandler {
    func handle(navigationRequest: NavigationRequest, completion:()->())
}

extension ScreenNavigator {
    static func navigationRequest(forPushNotification notification: PushNotification<WasherPushNotificationType>) -> NavigationRequest? {
        switch notification.type {
        case .washflow(let info):
            return navigationRequest(forWashflowInfo: info)
        case .badges(let info):
            return navigationRequest(forBadgeInfo: info)
        }
    }
    
    static func navigationRequest(basedOnLastAppState state: LastAppState) -> NavigationRequest? {
        switch state.appUserStatus! {
        case .postLoginScreen:
            return NavigationRequest(screen: WasherAppScreenCategory.login(.mandatoryVideo))
        case .washerWatchedAllMandatoryVideo, .washerIsOffline:
            return NavigationRequest(screen: WasherAppScreenCategory.wash(.dashboard))
        case .washerIsOnlineAsLocationAnMobileWasher, .washerIsOnlineAsLocationWasher, .washerIsOnlineAsMobileWasher, .washerAddRatingForWash, .washerAcceptedJobAndWaitingForConfirmations:
            return NavigationRequest(screen: WasherAppScreenCategory.wash(.lookingForUser))
        case .userConfirmedWasher:
            let info = state.washflowInfo!
            return NavigationRequest(screen: WasherAppScreenCategory.wash(.userAcceptsJob(bookingId: info.bookingId, userId: info.userId, washerId: info.washerId)))
        case .washerStartWashProcess:
            return NavigationRequest(screen: WasherAppScreenCategory.wash(.washInProgress(bookingId: state.washflowInfo!.bookingId!)))
        case .washerFinishWash:
            let info = state.washflowInfo!
            return NavigationRequest(screen: WasherAppScreenCategory.wash(.reviewUser(bookingId: info.bookingId!, washerId: info.washerId!)))
        case .userSubmitsDamages:
            return NavigationRequest(screen: WasherAppScreenCategory.wash(.userConfirmedDamages(bookingId: state.washflowInfo!.bookingId)))
        case .washerArrived:
            return NavigationRequest(screen: WasherAppScreenCategory.wash(.userSubmitDamages(bookingId: state.washflowInfo!.bookingId)))
        case .userAddedWashLocationAndWaitingForWasher:
            let info = state.washflowInfo!
            return NavigationRequest(screen: WasherAppScreenCategory.wash(.jobFound(bookingId: info.bookingId, userId: info.userId)))
        case .washerSubmitsDamagesAndWaitingForApproval:
            return NavigationRequest(screen: WasherAppScreenCategory.wash(.washerSubmitsDamagesAndWaitingForApproval(bookingId: state.washflowInfo!.bookingId)))
        case .userApprovedDamagesAddedByWasher:
            return NavigationRequest(screen: WasherAppScreenCategory.wash(.userApprovedDamagesAddedByWasher(bookingId: state.washflowInfo!.bookingId)))
        default:
            return nil
        }
    }
    
    fileprivate static func navigationRequest(forWashflowInfo info: WashflowInfoMessage) -> NavigationRequest? {
        switch info.status! {
        case .jobFound:
            return NavigationRequest(screen: WasherAppScreenCategory.wash(.jobFound(bookingId: info.bookingId, userId: info.userId)))
        case .userAcceptsJob, .scheduledWashReminderForWasher:
            return NavigationRequest(screen: WasherAppScreenCategory.wash(.userAcceptsJob(bookingId: info.bookingId, userId: info.userId, washerId: info.washerId)))
        case .userConfirmedDamage:
            return NavigationRequest(screen: WasherAppScreenCategory.wash(.userConfirmedDamages(bookingId: info.bookingId)))
        case .userCancelledWash:
            return NavigationRequest(screen: WasherAppScreenCategory.wash(.userCancelWash))
        default:
            return nil
        }
    }
    
    fileprivate static func navigationRequest(forBadgeInfo info: BadgeInfoMessage) -> NavigationRequest? {
        return NavigationRequest(screen: WasherAppScreenCategory.badge(.defaultBadgeScreen(message: info.message, imageURL: info.imageUrl)))
    }
}

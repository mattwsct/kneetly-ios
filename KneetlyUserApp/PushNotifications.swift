//
//  PushNotificationParser.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 1/31/17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import KneetlyCommon

class UserPushNotificatationParserProvider {
    
    static let parser: PushNotificationParser<UserPushNotificationType> = {
        let result = PushNotificationParser<UserPushNotificationType>()
        result.parseImpl = { (data, type) in
            return parseUserNotification(withData: data, category: type)
        }
        
        return result
    }()
    
    static func parseUserNotification(withData data: [String: Any], category: PushNotificationCategory) -> UserPushNotificationType?  {
        switch category {
        case .washflow:
            guard let info = PushNotificationParser<UserPushNotificationType>.parseWashflowNotification(data: data) else {
                return nil
            }
            return UserPushNotificationType.washflow(info)
        case .badges:
            guard let info = PushNotificationParser<UserPushNotificationType>.parseBadgeNotification(data: data) else {
                return nil
            }
            return UserPushNotificationType.badges(info)
        case .payment:
            guard let info = PushNotificationParser<UserPushNotificationType>.parsePaymentNotification(data: data) else {
                return nil
            }
            return UserPushNotificationType.payment(info)
        default:
            return nil
        }
    }
}

enum UserPushNotificationType: PushNotificationType {
    case washflow(WashflowInfoMessage)
    case badges(BadgeInfoMessage)
    case payment(PaymentInfoMessage)
}

extension NavigationRequest {
    func toUserAppNavigationRequest() -> UserAppNavigationRequest? {
        guard let category = self.screen as? UserAppScreenCategory else {
            return nil
        }
        
        return UserAppNavigationRequest(screen: category, info: self.info)
    }
}

public struct UserAppNavigationRequest {
    let screen: UserAppScreenCategory
    let info: [String: Any]?
}

enum UserAppScreenCategory: ScreenCategory {
    
    case wash(WashScreen)
    case badge(BadgeScreen)
    case registration(RegistrationScreen)
    
    public var requiredScreenPresenter: ScreenRequiredPresenter {
        switch self {
        case .registration(_):
            return .loginScreen
        default:
            return .mainScreen   
        }
    }
}

enum WashScreen {
    case washerFound(bookingId: String , washerID: String)
    case noWasherFound(bookingId: String)
    case washerNotReplied(bookingId: String)
    case washerNoAvailable(bookingId: String)
    case washInProgress(bookingId: String)
    case washCompleted(bookingId: String)
    case washerArrived(bookingId: String)
    case washerAddedDamages(bookingId: String)
    case cancelBooking(bookingId: String , vehicleId: String, washerId: String)
    case dashboard
    case confirmBooking(bookingId: String, vehicleId: String)
    case searchForWasher(bookingId: String)
    case washerIsWaiting(bookingId: String , userId: String, washerId: String)
    case reviewWasher(bookingId: String, washerId: String)
    case paymentDeclined(bookingId: String, vehicleId: String)
}

enum RegistrationScreen {
    case credentials
    case profileSetup
    case registerCar
    case addCardInformation
    case termsAndConditions
}

protocol UserAppNavigationRequestHandler {
    func handle(navigationRequest: NavigationRequest, completion:()->())
}

extension ScreenNavigator {
    
    static func navigationRequest(forPushNotification notification: PushNotification<UserPushNotificationType>) -> NavigationRequest? {
        switch notification.type {
        case .washflow(let info):
            return navigationRequest(forWashflowInfo: info)
        case .badges(let info):
            return navigationRequest(forBadgeInfo: info)
        case .payment(let info):
            return navigationRequest(forPaymentInfo: info)
        }
    }
    
    static func navigationRequest(basedOnLastAppState state: LastAppState) -> NavigationRequest? {
        let info = state.washflowInfo
        switch state.appUserStatus! {
        case .postLoginScreen:
            return NavigationRequest(screen: UserAppScreenCategory.registration(.registerCar))
        case .userRegistered:
            return NavigationRequest(screen:UserAppScreenCategory.registration(.profileSetup))
        case .userAddedVehicleInformation:
            return NavigationRequest(screen:UserAppScreenCategory.registration(.addCardInformation))
        case .userAddedCreditCardInformations:
            return NavigationRequest(screen:UserAppScreenCategory.registration(.termsAndConditions))
        case .userAcceptsTermsAndConditions:
            return NavigationRequest(screen:UserAppScreenCategory.wash(.dashboard))
        case .userBookedWash:
            return NavigationRequest(screen:UserAppScreenCategory.wash(.confirmBooking(bookingId: info!.bookingId,
                                                                                       vehicleId: info!.vehicleId!)))
        case .userAddedWashLocationAndWaitingForWasher, .userRejectWasherOrCancelSearch:
             return NavigationRequest(screen:UserAppScreenCategory.wash(.searchForWasher(bookingId: info!.bookingId)))
        case .washerAcceptedJobAndWaitingForConfirmations:
            return NavigationRequest(screen: UserAppScreenCategory.wash(.washerFound(bookingId: info!.bookingId, washerID: info!.washerId)))
        case .userConfirmedWasher:
            return NavigationRequest(screen: UserAppScreenCategory.wash(.washerIsWaiting(bookingId: info!.bookingId, userId: info!.userId, washerId: info!.washerId)))
        case .washerArrived:
            return NavigationRequest(screen: UserAppScreenCategory.wash(.washerArrived(bookingId: info!.bookingId)))
        case .userApprovedDamagesAddedByWasher, .washerStartWashProcess:
            return NavigationRequest(screen: UserAppScreenCategory.wash(.washInProgress(bookingId: info!.bookingId)))
        case .washerFinishWash:
            return NavigationRequest(screen: UserAppScreenCategory.wash(.washCompleted(bookingId: info!.bookingId)))
        case .userAddRatingForWash:
            return NavigationRequest(screen: UserAppScreenCategory.wash(.reviewWasher(bookingId: info!.bookingId, washerId: info!.washerId)))
        case .washerSubmitsDamagesAndWaitingForApproval:
            return NavigationRequest(screen: UserAppScreenCategory.wash(.washerAddedDamages(bookingId: info!.bookingId)))
        case .washerRejectsJobRequest:
            return NavigationRequest(screen: UserAppScreenCategory.wash(.cancelBooking(bookingId: info!.bookingId, vehicleId: info!.vehicleId!, washerId: info!.washerId)))
        default:
            return nil
        }
    }
    
    fileprivate static func navigationRequest(forWashflowInfo info: WashflowInfoMessage) -> NavigationRequest? {
        var category: UserAppScreenCategory?
        switch info.status! {
        case .washerFound:
            category = UserAppScreenCategory.wash(.washerFound(bookingId: info.bookingId, washerID: info.washerId))
        case .noWasherFound:
            category = UserAppScreenCategory.wash(.noWasherFound(bookingId: info.bookingId))
        case .washerIsUnavailable:
            category = UserAppScreenCategory.wash(.washerNoAvailable(bookingId: info.bookingId))
        case .washerHasNotResponded:
            category = UserAppScreenCategory.wash(.washerNotReplied(bookingId: info.bookingId))
        case .washStarted:
            category = UserAppScreenCategory.wash(.washInProgress(bookingId: info.bookingId))
        case .washCompleted:
            category = UserAppScreenCategory.wash(.washCompleted(bookingId: info.bookingId))
        case .washerArrived:
            category = UserAppScreenCategory.wash(.washerArrived(bookingId: info.bookingId))
        case.washerAddedDamage:
            category = UserAppScreenCategory.wash(.washerAddedDamages(bookingId: info.bookingId))
        case .washerCancelledBooking:
            category = UserAppScreenCategory.wash(.cancelBooking(bookingId: info.bookingId, vehicleId: info.vehicleId!, washerId: info.washerId))
        default:
            break
        }
        
        guard let resultCategory = category else {
            return nil
        }
        
        return NavigationRequest(screen: resultCategory)
    }
    
    fileprivate static func navigationRequest(forBadgeInfo info: BadgeInfoMessage) -> NavigationRequest? {
        return NavigationRequest(screen: UserAppScreenCategory.badge(.defaultBadgeScreen(message: info.message, imageURL: info.imageUrl)))
    }
    
    fileprivate static func navigationRequest(forPaymentInfo info: PaymentInfoMessage) -> NavigationRequest? {
        if info.status! == .paymentDeclined {
            let category = UserAppScreenCategory.wash(.paymentDeclined(bookingId: info.bookingId, vehicleId: info.vehicleId!))
            return NavigationRequest(screen: category)
        }
        
        return nil
    }
}

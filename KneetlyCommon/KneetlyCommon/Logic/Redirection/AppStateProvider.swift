//
//  UserStatusProvider.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 2/20/17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import ObjectMapper

public enum AppUserStatus: Int {
    case  unknown = 0
    case  userRegistered = 1000
    case  postLoginScreen = 1001
    case  washerWatchedAllMandatoryVideo = 1002
    case  washerIsOnlineAsMobileWasher = 1003
    case  washerIsOnlineAsLocationWasher = 1004
    case  washerIsOnlineAsLocationAnMobileWasher = 1005
    case  washerIsOffline = 1006
    case  userAddedVehicleInformation = 1007
    case  userAddedCreditCardInformations = 1008
    case  userAcceptsTermsAndConditions = 1009
    case  userBookedWash = 1010
    case  userAddedWashLocationAndWaitingForWasher = 1011
    case  washerAcceptedJobAndWaitingForConfirmations = 1012
    case  washerRejectsJobRequest = 1013
    case  userConfirmedWasher = 1014
    case  userRejectWasherOrCancelSearch = 1015
    case  washerArrived = 1016
    case  userSubmitsDamages = 1017
    case  washerSubmitsDamagesAndWaitingForApproval = 1018
    case  userApprovedDamagesAddedByWasher = 1019
    case  washerStartWashProcess = 1020
    case  washerFinishWash = 1021
    case  washerAddRatingForWash = 1022
    case  userAddRatingForWash = 1023
    case  noNavigation = 2000
}

public class LastAppState: ApiObject {
    public private(set) var appUserStatus: AppUserStatus!
    public private(set) var washflowInfo: WashflowInfoMessage?
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        appUserStatus <- map["redirections.code"]
        washflowInfo <- map["redirections"]
        
        if appUserStatus == nil {
           appUserStatus = .unknown
        }

    }
    
    public convenience init?(forBooking booking: BookingWash) {
        self.init()
        appUserStatus = booking.bookingStatus
        
        let bookingWashflowInfo = WashflowInfoMessage(forBooking: booking)
        
        washflowInfo = bookingWashflowInfo
    }
}

public class AppStateProvider {
    
    private let requestSender: RequestSender
    
    private let updateRequest: ApiRequest<LastAppState, ApiErrorCategory<ApiDefaultError>>
    
    public private(set) var lastLoadedState: LastAppState?
    
    public init(requestSender: RequestSender, updateRequest: ApiRequest<LastAppState, ApiErrorCategory<ApiDefaultError>>) {
        self.requestSender = requestSender
        self.updateRequest = updateRequest
    }
    
    public func updateState(withCompletion completion:@escaping (LastAppState?)->()) {
        requestSender.sendRequest(apiRequest: updateRequest) { (result) in
            if let state = result.value {
                self.lastLoadedState = state
            }
            completion(result.value)
        }
    }
}

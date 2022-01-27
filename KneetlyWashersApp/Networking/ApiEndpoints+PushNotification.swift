//
//  ApiEndpoints+PushNotification.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 2/2/17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation

import KneetlyCommon

extension ApiEndpoints {
    
    public struct PushNotification {
        public static func updateFCMTokenRequest(token: String) -> ApiRequest<ApiObject, ApiErrorCategory<ApiDefaultError>> {
            return ApiEndpoints.CommonPushNotification.updateFCMTokenRequest(token: token, methodName: "washer/fcm/update")
        }
    }
}

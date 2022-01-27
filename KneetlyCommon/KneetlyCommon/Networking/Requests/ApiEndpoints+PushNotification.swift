//
//  ApiEndpoints+PushNotification.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 2/2/17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation

extension ApiEndpoints {
    
    public struct CommonPushNotification {
        
        public static func updateFCMTokenRequest(token: String, methodName: String) -> ApiRequest<ApiObject, ApiErrorCategory<ApiDefaultError>> {
            return ApiRequest(
                httpMethod: .post,
                apiMethodName: methodName,
                params: ["token" : token],
                expectedResponseType: .object,
                responseHandler: { (response: ApiResponse) -> RequestResult<ApiObject, ApiErrorCategory<ApiDefaultError>> in
                    return ResponseMapper.mapObjectResponse(response: response, type: ApiObject.self)
            })
        }

    }
}

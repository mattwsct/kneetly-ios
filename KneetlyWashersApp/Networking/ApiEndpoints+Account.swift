//
//  File.swift
//  KneetlyWashersApp
//
//  Created by Matt Westcott on 1/10/17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import KneetlyCommon

extension ApiEndpoints {
    
    public struct Account {
        
        public static func loginRequest(firebaseToken: String,
                                        clientSecret: String,
                                        clientId: String,
                                        grantType: String) -> ApiRequest<LoginResult, ApiErrorCategory<ApiLoginError>> {
            return ApiRequest(httpMethod: .post,
                              apiMethodName: "washer/login",
                              params: ["grant_type": grantType, "client_id": clientId, "client_secret": clientSecret, "firebase_token": firebaseToken],
                              expectedResponseType: .object,
                              responseHandler: { (response: ApiResponse) -> RequestResult<LoginResult, ApiErrorCategory<ApiLoginError>> in
                                return ResponseMapper.mapObjectResponse(response: response, type: LoginResult.self)
            })
        }
        
        public static func logoutRequest(fcmToken: String?) -> ApiRequest<ApiObject, ApiErrorCategory<ApiDefaultError>> {
            var params: [String: Any] = [:]
            if let fcmToken = fcmToken {
                params["fcm_token"] = fcmToken
            }
            
            return ApiRequest(httpMethod: .post,
                              apiMethodName: "washer/logout",
                              params: params,
                              expectedResponseType: .object,
                              responseHandler: { (response: ApiResponse) -> RequestResult<ApiObject, ApiErrorCategory<ApiDefaultError>> in
                                return ResponseMapper.mapObjectResponse(response: response, type: ApiObject.self)
            })
        }
        
        static func fetchStatusRequest() -> ApiRequest<LastAppState, ApiErrorCategory<ApiDefaultError>> {
            return ApiRequest(httpMethod: .get,
                              apiMethodName: "washer/check/process",
                              params: nil,
                              expectedResponseType: .object,
                              responseHandler: { (response: ApiResponse) -> RequestResult<LastAppState, ApiErrorCategory<ApiDefaultError>> in
                                return ResponseMapper.mapObjectResponse(response: response, type: LastAppState.self)
            })
        }
    }
    
}

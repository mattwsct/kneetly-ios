//
//  ApiEndpoints+Account.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 1/12/17.
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
                              apiMethodName: "users/login",
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
                              apiMethodName: "users/logout",
                              params: params,
                              expectedResponseType: .object,
                              responseHandler: { (response: ApiResponse) -> RequestResult<ApiObject, ApiErrorCategory<ApiDefaultError>> in
                                return ResponseMapper.mapObjectResponse(response: response, type: ApiObject.self)
            })
        }
        
        public static func registerRequest(firebaseToken: String,
                                           clientSecret: String,
                                           clientId: String,
                                           grantType: String) -> ApiRequest<LoginResult, ApiErrorCategory<ApiRegisterError>> {
            let params = ["grant_type": grantType, "client_id": clientId, "client_secret": clientSecret, "firebase_token": firebaseToken]
            let request = ApiRequest(httpMethod: .post,
                                     apiMethodName: "users/register",
                                     params: params,
                                     expectedResponseType: .object,
                                     responseHandler: { (response: ApiResponse) -> RequestResult<LoginResult, ApiErrorCategory<ApiRegisterError>> in
                                        return ResponseMapper.mapObjectResponse(response: response, type: LoginResult.self)
            })
            return request
        }
        
        
        public static func profileRequest() -> ApiRequest<User, ApiErrorCategory<ApiDefaultError>> {
            return ApiRequest(httpMethod: .get,
                              apiMethodName: "users/profile/get",
                              params: nil,
                              expectedResponseType: .object,
                              responseHandler: { (response: ApiResponse) -> RequestResult<User, ApiErrorCategory<ApiDefaultError>> in
                                return ResponseMapper.mapObjectResponse(response: response, type: User.self)
            })
        }
        
        public static func updateProfileRequest(parameters: [String: Any]) -> ApiRequest<ApiObject, ApiErrorCategory<ApiDefaultError>> {
            return ApiRequest(httpMethod: .post,
                              apiMethodName: "users/profile/update",
                              params: parameters,
                              expectedResponseType: .object,
                              responseHandler: { (response: ApiResponse) -> RequestResult<ApiObject, ApiErrorCategory<ApiDefaultError>> in
                                return ResponseMapper.mapObjectResponse(response: response, type: ApiObject.self)
                              }
            )
        }
        
        public static func addBusiness(parameters: [String: Any]) -> ApiRequest<ApiObject, ApiErrorCategory<ApiDefaultError>> {
            return ApiRequest(httpMethod: .post,
                              apiMethodName: "users/business/add",
                              params: parameters,
                              expectedResponseType: .object,
                              responseHandler: { (response: ApiResponse) -> RequestResult<ApiObject, ApiErrorCategory<ApiDefaultError>> in
                                return ResponseMapper.mapObjectResponse(response: response, type: ApiObject.self)
            })
        }
        
        public static func updateBusiness(id: String, parameters: [String: Any]) -> ApiRequest<ApiObject, ApiErrorCategory<ApiDefaultError>> {
            return ApiRequest(httpMethod: .post,
                              apiMethodName: "users/business/\(id)/update",
                              params: parameters,
                              expectedResponseType: .object,
                              responseHandler: { (response: ApiResponse) -> RequestResult<ApiObject, ApiErrorCategory<ApiDefaultError>> in
                                return ResponseMapper.mapObjectResponse(response: response, type: ApiObject.self)
            })
        }
        
        public static func businessList() -> ApiRequest<[Business], ApiErrorCategory<ApiDefaultError>> {
            let request = ApiRequest(httpMethod: .get,
                                     apiMethodName: "users/business/list",
                                     params: nil,
                                     expectedResponseType: .array,
                                     responseHandler: { (response: ApiResponse) -> RequestResult<[Business], ApiErrorCategory<ApiDefaultError>> in
                                        return ResponseMapper.mapResponseArray(response: response, type: Business.self)
            })
            return request
        }
        
        public static func getBusiness(id: String) -> ApiRequest<Business, ApiErrorCategory<ApiDefaultError>> {
            return ApiRequest(
                httpMethod: .get,
                apiMethodName: "users/business/\(id)/get",
                params: nil,
                expectedResponseType: .object,
                responseHandler: { (response: ApiResponse) -> RequestResult<Business, ApiErrorCategory<ApiDefaultError>> in
                    return ResponseMapper.mapObjectResponse(response: response, type: Business.self)
            }
            )
        }
        
        public static func removeBusiness(id: String) -> ApiRequest<ApiObject, ApiErrorCategory<ApiDefaultError>> {
            return ApiRequest(httpMethod: .post,
                              apiMethodName: "users/business/\(id)/delete",
                params: nil,
                expectedResponseType: .object,
                responseHandler: { (response: ApiResponse) -> RequestResult<ApiObject, ApiErrorCategory<ApiDefaultError>> in
                    return ResponseMapper.mapObjectResponse(response: response, type: ApiObject.self)
            })
        }
        
        static func fetchStatusRequest() -> ApiRequest<LastAppState, ApiErrorCategory<ApiDefaultError>> {
            return ApiRequest(httpMethod: .get,
                              apiMethodName: "users/check/process",
                params: nil,
                expectedResponseType: .object,
                responseHandler: { (response: ApiResponse) -> RequestResult<LastAppState, ApiErrorCategory<ApiDefaultError>> in
                    return ResponseMapper.mapObjectResponse(response: response, type: LastAppState.self)
            })
        }
    }
}

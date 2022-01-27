//
//  ApiEndpoints+Profile.swift
//  KneetlyWashersApp
//
//  Created by Matt Westcott on 07.02.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import KneetlyCommon

extension ApiEndpoints {
    
    struct ProfileRequest {
        public static func getProfile() -> ApiRequest<User, ApiErrorCategory<ApiDefaultError>> {
            return ApiRequest(
                httpMethod: .get,
                apiMethodName: "washer/profile/get",
                params: nil,
                expectedResponseType: .object,
                responseHandler: { (response: ApiResponse) -> RequestResult<User, ApiErrorCategory<ApiDefaultError>> in
                    return ResponseMapper.mapObjectResponse(response: response, type: User.self)
                }
            )
        }
        
        public static func updateProfile(params: [String : Any], avatar: Data?) -> ApiRequest<ApiObject, ApiErrorCategory<ApiDefaultError>> {
            var multipartParams: [String : Any] = [:]
            if (avatar != nil) {
                multipartParams["avatar"] = avatar!
            }
            return ApiRequest(
                httpMethod: .post,
                apiMethodName: "washer/profile/update",
                params: params,
                expectedResponseType: .object,
                multipartParams: multipartParams,
                responseHandler: { (response: ApiResponse) -> RequestResult<ApiObject, ApiErrorCategory<ApiDefaultError>> in
                    return ResponseMapper.mapObjectResponse(response: response, type: ApiObject.self)
                }
            )
        }
    }
}

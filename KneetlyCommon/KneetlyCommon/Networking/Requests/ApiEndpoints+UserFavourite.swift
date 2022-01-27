//
//  ApiEndpoints+Favourite.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 22.02.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation

extension ApiEndpoints {
    
    public struct UserFavouriteRequest {
        
        public static func add(washerId: String) -> ApiRequest<ApiObject, ApiErrorCategory<ApiDefaultError>>  {
            return ApiRequest(
                httpMethod: .post,
                apiMethodName: "users/washer/favorite/add",
                params: ["washer_id" : washerId],
                expectedResponseType: .object,
                responseHandler: { (response: ApiResponse) -> RequestResult<ApiObject, ApiErrorCategory<ApiDefaultError>> in
                    return ResponseMapper.mapObjectResponse(response: response, type: ApiObject.self)
                }
            )
        }
    }
}

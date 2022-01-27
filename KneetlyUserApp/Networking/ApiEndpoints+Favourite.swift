//
//  ApiEndpoints+Favourite.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 18.01.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import KneetlyCommon

extension ApiEndpoints {
    
    public struct Favorite {
        
        public static func addRequest(washerId: String) -> ApiRequest<ApiObject, ApiErrorCategory<ApiDefaultError>>  {
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
        
        public static func deleteRequest(washerId: String) -> ApiRequest<ApiObject, ApiErrorCategory<ApiDefaultError>>  {
            return ApiRequest(
                httpMethod: .get,
                apiMethodName: "users/washer/favorite/delete/\(washerId)",
                params: nil,
                expectedResponseType: .object,
                responseHandler: { (response: ApiResponse) -> RequestResult<ApiObject, ApiErrorCategory<ApiDefaultError>> in
                    return ResponseMapper.mapObjectResponse(response: response, type: ApiObject.self)
                }
            )
        }
        
        public static func listRequest() -> ApiRequest<[WasherUser], ApiErrorCategory<ApiDefaultError>>  {
            return ApiRequest(
                httpMethod: .get,
                apiMethodName: "users/washer/favorite/list",
                params: nil,
                expectedResponseType: .array,
                responseHandler: { (response: ApiResponse) -> RequestResult<[WasherUser], ApiErrorCategory<ApiDefaultError>> in
                    return ResponseMapper.mapResponseArray(response: response, type: WasherUser.self)
                }
            )
        }
    }
}

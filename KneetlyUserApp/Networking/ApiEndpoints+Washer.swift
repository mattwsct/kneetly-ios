//
//  ApiEndpoints+Washer.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 19/01/2017.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import KneetlyCommon

extension ApiEndpoints {
    
    struct Washer {
        static func nearbyWashersRequest(latitude: Double, longitude: Double, radius: Double?) -> ApiRequest<NearbyWashersList, ApiErrorCategory<ApiDefaultError>> {
            var params = [ "lat" : latitude,
                           "lon" : longitude ]
            if let radius = radius {
                params["radius"] = radius
            }
            
            let request = ApiRequest(httpMethod: .get,
                                     apiMethodName: "users/nearbyWasher",
                                     params: params,
                                     expectedResponseType: .array,
                                     responseHandler: { (response: ApiResponse) -> RequestResult<NearbyWashersList, ApiErrorCategory<ApiDefaultError>> in
                return ResponseMapper.mapObjectResponse(response: response, type: NearbyWashersList.self)
            })
            return request
        }
        
        public static func getWasher(id: String) -> ApiRequest<WasherUser, ApiErrorCategory<ApiDefaultError>> {
            return ApiRequest(
                httpMethod: .get,
                apiMethodName: "users/washer/get/\(id)",
                params: nil,
                expectedResponseType: .object,
                responseHandler: { (response: ApiResponse) -> RequestResult<WasherUser, ApiErrorCategory<ApiDefaultError>> in
                    return ResponseMapper.mapObjectResponse(response: response, type: WasherUser.self)
                }
            )
        }
        
        public static func getWasherAsUser(id: String) -> ApiRequest<User, ApiErrorCategory<ApiDefaultError>> {
            return ApiRequest(
                httpMethod: .get,
                apiMethodName: "users/washer/get/\(id)",
                params: nil,
                expectedResponseType: .object,
                responseHandler: { (response: ApiResponse) -> RequestResult<User, ApiErrorCategory<ApiDefaultError>> in
                    return ResponseMapper.mapObjectResponse(response: response, type: User.self)
                }
            )
        }
    }
}

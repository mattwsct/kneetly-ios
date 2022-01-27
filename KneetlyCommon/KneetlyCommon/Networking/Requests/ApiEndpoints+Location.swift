//
//  ApiEndpoints+Location.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 03.02.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation

extension ApiEndpoints {
    
    public struct LocationRequest {
        public static func updateMyLocationRequest(
            consumer: String,
            latitude: Double,
            longitude: Double) -> ApiRequest<ApiObject, ApiErrorCategory<ApiDefaultError>> {
            return ApiRequest(
                httpMethod: .post,
                apiMethodName: "\(consumer)/currentlocation/update",
                params: ["latitude" : latitude, "longitude" : longitude],
                expectedResponseType: .object,
                responseHandler: { (response: ApiResponse) -> RequestResult<ApiObject, ApiErrorCategory<ApiDefaultError>> in
                    return ResponseMapper.mapObjectResponse(response: response, type: ApiObject.self)
                }
            )
        }
    }
}

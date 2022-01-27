//
//  ApiEndpoints+Location.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 01.02.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import KneetlyCommon

extension ApiEndpoints {
    
    public struct LocationRequest {
        public static func getWasherLocationRequest(washerId: String) -> ApiRequest<Location, ApiErrorCategory<ApiDefaultError>> {
            return ApiRequest(
                httpMethod: .get,
                apiMethodName: "users/washer/\(washerId)/currentlocation/get",
                params: nil,
                expectedResponseType: .object,
                responseHandler: { (response: ApiResponse) -> RequestResult<Location, ApiErrorCategory<ApiDefaultError>> in
                    return ResponseMapper.mapObjectResponse(response: response, type: Location.self)
                }
            )
        }
    }
}

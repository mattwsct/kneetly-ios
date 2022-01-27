//
//  ApiEndpoints+Location.swift
//  KneetlyWashersApp
//
//  Created by Matt Westcott on 03.02.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import KneetlyCommon

extension ApiEndpoints {
    
    public struct LocationRequest {
        public static func getUserLocationRequest(userId: String) -> ApiRequest<Location, ApiErrorCategory<ApiDefaultError>> {
            return ApiRequest(
                httpMethod: .get,
                apiMethodName: "washer/user/\(userId)/currentlocation/get",
                params: nil,
                expectedResponseType: .object,
                responseHandler: { (response: ApiResponse) -> RequestResult<Location, ApiErrorCategory<ApiDefaultError>> in
                    return ResponseMapper.mapObjectResponse(response: response, type: Location.self)
                }
            )
        }
    }
}

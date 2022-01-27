//
//  ApiEndpoints+Badges.swift
//  KneetlyWashersApp
//
//  Created by Matt Westcott on 30.01.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import KneetlyCommon

extension ApiEndpoints {
    
    public struct Badges {
        public static func getBadges() -> ApiRequest<[Badge], ApiErrorCategory<ApiDefaultError>>  {
            return ApiRequest(
                httpMethod: .get,
                apiMethodName: "washer/badges",
                params: nil,
                expectedResponseType: .array,
                responseHandler: { (response: ApiResponse) -> RequestResult<[Badge], ApiErrorCategory<ApiDefaultError>> in
                    return ResponseMapper.mapResponseArray(response: response, type: Badge.self)
                }
            )
        }
    }
}

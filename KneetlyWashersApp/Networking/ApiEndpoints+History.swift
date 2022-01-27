//
//  ApiEndpoints+History.swift
//  KneetlyWashersApp
//
//  Created by Matt Westcott on 16.02.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import KneetlyCommon

extension ApiEndpoints {
    
    public struct HistoryRequest {
        public static func getWashHistory() -> ApiRequest<[BookingWash], ApiErrorCategory<ApiDefaultError>> {
            return ApiRequest(
                httpMethod: .get,
                apiMethodName: "washer/wash/list",
                params: nil,
                expectedResponseType: .array,
                responseHandler: { (response: ApiResponse) -> RequestResult<[BookingWash], ApiErrorCategory<ApiDefaultError>> in
                    return ResponseMapper.mapResponseArray(response: response, type: BookingWash.self)
                }
            )
        }
    }
}

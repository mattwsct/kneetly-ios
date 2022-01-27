//
//  ApiEndpoints+Booking.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 06.02.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation

extension ApiEndpoints {
    
    public struct WashRequest {
        
        public static func washTypeRequest(forVehicleType type: CarType) -> ApiRequest<[WashType], ApiErrorCategory<ApiDefaultError>> {
            let request = ApiRequest(
                httpMethod: .get,
                apiMethodName: "washtype/list",
                params: ["vehicle_type" : type.rawValue],
                expectedResponseType: .array,
                responseHandler: { (response: ApiResponse) -> RequestResult<[WashType], ApiErrorCategory<ApiDefaultError>> in
                    return ResponseMapper.mapResponseArray(response: response, type: WashType.self)
                }
            )
            return request
        }
    }
}

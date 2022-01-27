//
//  ApiEndpoints+Vehicle.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 06.02.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation

extension ApiEndpoints {
    
    public struct VehicleRequest {
        
        public static func getVehicle(id: String) -> ApiRequest<Vehicle, ApiErrorCategory<ApiDefaultError>> {
            let request = ApiRequest(
                httpMethod: .get,
                apiMethodName: "vehicle/get/\(id)",
                params: nil,
                expectedResponseType: .object,
                responseHandler: { (response: ApiResponse) -> RequestResult<Vehicle, ApiErrorCategory<ApiDefaultError>> in
                    return ResponseMapper.mapObjectResponse(response: response, type: Vehicle.self)
                }
            )
            return request
        }
    }
}

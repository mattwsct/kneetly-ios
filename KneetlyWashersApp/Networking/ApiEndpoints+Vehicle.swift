//
//  ApiEndpoints+Vehicle.swift
//  KneetlyWashersApp
//
//  Created by Matt Westcott on 20/02/2017.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import KneetlyCommon

extension ApiEndpoints {
    
    struct Vehicles {
        public static func vehicleListRequest(userId: String) -> ApiRequest<[Vehicle], ApiErrorCategory<ApiDefaultError>> {
            let request = ApiRequest(httpMethod: .get,
                                     apiMethodName: "washer/users/\(userId)/vehicle/list",
                                     params: nil,
                                     expectedResponseType: .array,
                                     responseHandler: { (response: ApiResponse) -> RequestResult<[Vehicle], ApiErrorCategory<ApiDefaultError>> in
                                        return ResponseMapper.mapResponseArray(response: response, type: Vehicle.self)
            })
            return request
        }
    }
    
}

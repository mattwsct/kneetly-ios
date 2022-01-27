//
//  ApiEndpoints+WashProcess.swift
//  KneetlyWashersApp
//
//  Created by Matt Westcott on 17/02/2017.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import KneetlyCommon

extension ApiEndpoints {
    
    public struct WashProcess {
        static func arrivedRequest(bookingId: String) -> ApiRequest<ApiObject, ApiErrorCategory<ApiDefaultError>> {
            let request = ApiRequest(httpMethod: .post,
                                     apiMethodName: "washer/wash/\(bookingId)/arrived",
                params: nil,
                expectedResponseType: .object,
                responseHandler: { (response: ApiResponse) -> RequestResult<ApiObject, ApiErrorCategory<ApiDefaultError>> in
                    return ResponseMapper.mapObjectResponse(response: response, type: ApiObject.self)
            })
            return request
        }
        
        static func finishRequest(bookingId: String) -> ApiRequest<ApiObject, ApiErrorCategory<ApiDefaultError>> {
            let request = ApiRequest(httpMethod: .post,
                                     apiMethodName: "washer/wash/\(bookingId)/finish",
                params: nil,
                expectedResponseType: .object,
                responseHandler: { (response: ApiResponse) -> RequestResult<ApiObject, ApiErrorCategory<ApiDefaultError>> in
                    return ResponseMapper.mapObjectResponse(response: response, type: ApiObject.self)
            })
            return request
        }
    }
}

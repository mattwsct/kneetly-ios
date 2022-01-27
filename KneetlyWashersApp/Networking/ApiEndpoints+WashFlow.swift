//
//  ApiEndpoints+WashFlow.swift
//  KneetlyWashersApp
//
//  Created by Artur Chernov on 11.05.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import KneetlyCommon

extension ApiEndpoints {
    
    public struct WashFlow {
        
        public static func getCurrentState() -> ApiRequest<LastAppState, ApiErrorCategory<ApiDefaultError>> {
            return ApiRequest(
                httpMethod: .post,
                apiMethodName: "washer/backgroundrefresh",
                params: nil,
                expectedResponseType: .object,
                responseHandler: { (response: ApiResponse) -> RequestResult<LastAppState, ApiErrorCategory<ApiDefaultError>> in
                    return ResponseMapper.mapObjectResponse(response: response, type: LastAppState.self)
                }
            )
        }
    }
}

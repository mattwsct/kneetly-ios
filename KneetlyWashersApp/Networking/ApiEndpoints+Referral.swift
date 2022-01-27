//
//  ApiEndpoints+Referral.swift
//  KneetlyWashersApp
//
//  Created by Matt Westcott on 14.02.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import KneetlyCommon

extension ApiEndpoints {
    
    public struct ReferralRequest {
        public static func getLink() -> ApiRequest<ReferralCode, ApiErrorCategory<ApiDefaultError>> {
            return ApiRequest(
                httpMethod: .get,
                apiMethodName: "washer/referral/get",
                params: nil,
                expectedResponseType: .object,
                responseHandler: { (response: ApiResponse) -> RequestResult<ReferralCode, ApiErrorCategory<ApiDefaultError>> in
                    return ResponseMapper.mapObjectResponse(response: response, type: ReferralCode.self)
                }
            )
        }
    }
}

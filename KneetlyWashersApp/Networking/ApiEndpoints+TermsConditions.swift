//
//  ApiEndpoints+TermsConditions.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 26.01.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import KneetlyCommon

extension ApiEndpoints {
    
    public struct TermsAndConditions {
        public static func getTermsAndConditionsRequest() -> ApiRequest<TermsConditions, ApiErrorCategory<ApiDefaultError>> {
            return ApiRequest(
                httpMethod: .get,
                apiMethodName: "washer/termsandconditions/get",
                params: nil,
                expectedResponseType: .object,
                responseHandler: { (response: ApiResponse) -> RequestResult<TermsConditions, ApiErrorCategory<ApiDefaultError>> in
                    return ResponseMapper.mapObjectResponse(response: response, type: TermsConditions.self)
                }
            )
        }
    }
}

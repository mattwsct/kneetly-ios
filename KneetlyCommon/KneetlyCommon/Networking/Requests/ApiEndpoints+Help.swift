//
//  ApiEndpoints+Help.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 27.01.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation

extension ApiEndpoints {
    
    public struct Help {
        
        public static func getCategoriesRequest(consumer: String) -> ApiRequest<[ProblemCategory], ApiErrorCategory<ApiDefaultError>> {
            return ApiRequest(
                httpMethod: .get,
                apiMethodName: "\(consumer)/category/help/list",
                params: nil,
                expectedResponseType: .array,
                responseHandler: { (response: ApiResponse) -> RequestResult<[ProblemCategory], ApiErrorCategory<ApiDefaultError>> in
                    return ResponseMapper.mapResponseArray(response: response, type: ProblemCategory.self)
                }
            )
        }
        public static func helpSubmitRequest(consumer: String, categoryId: String, comments: String = "") -> ApiRequest<ApiObject, ApiErrorCategory<ApiDefaultError>> {
            return ApiRequest(
                httpMethod: .post,
                apiMethodName: "\(consumer)/help/submit",
                params: ["categories_id" : categoryId, "comments" : comments],
                expectedResponseType: .object,
                responseHandler: { (response: ApiResponse) -> RequestResult<ApiObject, ApiErrorCategory<ApiDefaultError>> in
                    return ResponseMapper.mapObjectResponse(response: response, type: ApiObject.self)
                }
            )
        }
    }
}

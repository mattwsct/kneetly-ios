//
//  ApiEndpoints+Problem.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 23.01.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation

extension ApiEndpoints {
    
    public struct Problem {
        public static func getCategoriesRequest(consumer: String) -> ApiRequest<[ProblemCategory], ApiErrorCategory<ApiDefaultError>> {
            return ApiRequest(
                httpMethod: .get,
                apiMethodName: "\(consumer)/category/problem/list",
                params: nil,
                expectedResponseType: .array,
                responseHandler: { (response: ApiResponse) -> RequestResult<[ProblemCategory], ApiErrorCategory<ApiDefaultError>> in
                    return ResponseMapper.mapResponseArray(response: response, type: ProblemCategory.self)
                }
            )
        }
        public static func reportProblemRequest(consumer: String, bookingsId: String, description: String, category: String) -> ApiRequest<ApiObject, ApiErrorCategory<ApiDefaultError>> {
            return ApiRequest(
                httpMethod: .post,
                apiMethodName: "\(consumer)/wash/\(bookingsId)/problem",
                params: ["description" : description, "category" : category],
                expectedResponseType: .object,
                responseHandler: { (response: ApiResponse) -> RequestResult<ApiObject, ApiErrorCategory<ApiDefaultError>> in
                    return ResponseMapper.mapObjectResponse(response: response, type: ApiObject.self)
                }
            )
        }
    }
}

//
//  ApiEndpoints+Rating.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 22.02.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation

extension ApiEndpoints {
    
    public struct Rating {
        public static func addRequest(sender: ReviewSender, bookingsId: String, rating: Int,comments: String) -> ApiRequest<ApiObject, ApiErrorCategory<ApiDefaultError>>  {
            return ApiRequest(
                httpMethod: .post,
                apiMethodName: "\(sender.rawValue)/wash/\(bookingsId)/rating/add",
                params: ["rating" : rating, "comments" : comments],
                expectedResponseType: .object,
                responseHandler: { (response: ApiResponse) -> RequestResult<ApiObject, ApiErrorCategory<ApiDefaultError>> in
                    return ResponseMapper.mapObjectResponse(response: response, type: ApiObject.self)
                }
            )
        }
    }
}

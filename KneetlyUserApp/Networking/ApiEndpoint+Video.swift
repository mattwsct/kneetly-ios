//
//  ApiEndpoint+Video.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 2/17/17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import KneetlyCommon

extension ApiEndpoints {

    struct Video {
        
        static func tutorialRequest() -> ApiRequest<[VideoItem], ApiErrorCategory<ApiDefaultError>>  {
            return ApiRequest(
                httpMethod: .get,
                apiMethodName: "users/video/list",
                params: nil,
                expectedResponseType: .array,
                responseHandler: { (response: ApiResponse) -> RequestResult<[VideoItem], ApiErrorCategory<ApiDefaultError>> in
                    return ResponseMapper.mapResponseArray(response: response, type: VideoItem.self)
            })
        }
    }
    
}

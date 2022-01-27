//
//  ApiEndpoints+Video.swift
//  KneetlyWashersApp
//
//  Created by Matt Westcott on 1/26/17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import KneetlyCommon

extension ApiEndpoints {
    
    struct Video {
        
        static func tutorialRequest() -> ApiRequest<[VideoItem], ApiErrorCategory<ApiDefaultError>>  {
            return ApiRequest(
                httpMethod: .get,
                apiMethodName: "washer/video/list",
                params: nil,
                expectedResponseType: .array,
                responseHandler: { (response: ApiResponse) -> RequestResult<[VideoItem], ApiErrorCategory<ApiDefaultError>> in
                    return ResponseMapper.mapResponseArray(response: response, type: VideoItem.self)
            })

        }
        
        static func unwatchedVideoRequest() -> ApiRequest<[VideoItem], ApiErrorCategory<ApiDefaultError>>  {
            return ApiRequest(
                httpMethod: .get,
                apiMethodName: "washer/video/unwatched",
                params: nil,
                expectedResponseType: .array,
                responseHandler: { (response: ApiResponse) -> RequestResult<[VideoItem], ApiErrorCategory<ApiDefaultError>> in
                    let result: RequestResult<[VideoItem], ApiErrorCategory<ApiDefaultError>> = ResponseMapper.mapResponseArray(response: response, type: VideoItem.self)
                    switch result {
                    case .success(let items):
                        items.forEach({ $0.isWatched = false})
                    case .failure(_): break
                    }
                    return result
            })
        }
        
        static func videoListRequest(withMethodName methodName: String) -> ApiRequest<[VideoItem], ApiErrorCategory<ApiDefaultError>>  {
            return ApiRequest(
                httpMethod: .get,
                apiMethodName: methodName,
                params: nil,
                expectedResponseType: .array,
                responseHandler: { (response: ApiResponse) -> RequestResult<[VideoItem], ApiErrorCategory<ApiDefaultError>> in
                    return ResponseMapper.mapResponseArray(response: response, type: VideoItem.self)
            })
        }
        
        static func markAsWathedRequest(videoId: String) -> ApiRequest<ApiObject, ApiErrorCategory<ApiDefaultError>>  {
            return ApiRequest(
                httpMethod: .post,
                apiMethodName: "washer/video/\(videoId)/show",
                params: nil,
                expectedResponseType: .object,
                responseHandler: { (response: ApiResponse) -> RequestResult<ApiObject, ApiErrorCategory<ApiDefaultError>> in
                    return ResponseMapper.mapObjectResponse(response:  response, type: ApiObject.self)
            })
        }
    }

}

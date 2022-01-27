//
//  ApiEndpoints+Favourites.swift
//  KneetlyWashersApp
//
//  Created by Matt Westcott on 08.02.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import KneetlyCommon

extension ApiEndpoints {
    
    struct FavouritesRequest {
        public static func getFavourites() -> ApiRequest<[FavouritedUser], ApiErrorCategory<ApiDefaultError>> {
            return ApiRequest(
                httpMethod: .get,
                apiMethodName: "washer/favorites",
                params: nil,
                expectedResponseType: .array,
                responseHandler: { (response: ApiResponse) -> RequestResult<[FavouritedUser], ApiErrorCategory<ApiDefaultError>> in
                    return ResponseMapper.mapResponseArray(response: response, type: FavouritedUser.self)
                }
            )
        }
    }
}

//
//  ApiEndpoints+WashChange.swift
//  KneetlyWashersApp
//
//  Created by Matt Westcott on 23.02.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import KneetlyCommon

extension ApiEndpoints {
    
    struct WashChangeRequest {
        
        public static func update(bookingId: String, priceDifference: Double, newWashTypeId: Int?, newVehicleId: String?, image: UIImage?, description: String?) -> ApiRequest<ApiObject, ApiErrorCategory<ApiDefaultError>> {
            var params: [String : Any] = ["charges" : priceDifference]
            if let newWashTypeId = newWashTypeId {
                params["washtype_id"] = "\(newWashTypeId)"
            }
            if let newVehicleId = newVehicleId {
                params["vehicle_id"] = newVehicleId
            }
            if let description = description {
                params["description"] = description
            }
            var multipartParams: [String : Any] = [:]
            if let image = image {
                if let imageData = UIImageJPEGRepresentation(image, 1) {
                    multipartParams["image"] = imageData
                }
            }
            return ApiRequest(
                httpMethod: .post,
                apiMethodName: "washer/wash/\(bookingId)/upgrade",
                params: params,
                expectedResponseType: .object,
                multipartParams: multipartParams,
                responseHandler: { (response: ApiResponse) -> RequestResult<ApiObject, ApiErrorCategory<ApiDefaultError>> in
                    return ResponseMapper.mapObjectResponse(response: response, type: ApiObject.self)
                }
            )
        }
    }
}

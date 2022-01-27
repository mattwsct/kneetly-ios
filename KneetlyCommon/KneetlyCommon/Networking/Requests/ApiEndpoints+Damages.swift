//
//  ApiEndpoints+Damages.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 25/01/2017.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import Alamofire

extension ApiEndpoints {
    
    struct Damages {
        static func addDamageRequest(bookingId: String, parameters: [String: Any], image: UIImage?, consumer: String) -> ApiRequest<ApiObject, ApiErrorCategory<ApiDefaultError>> {
            var multipartParams : [String: Any] = [:]
            if let damageImage = image?.resizeImage(newWidth: 500) {
                if let data = UIImageJPEGRepresentation(damageImage, 0.5) {
                    multipartParams = ["damage[imageurl]": data]
                    
                }
            }
            let request = ApiRequest(httpMethod: .post,
                                     apiMethodName: "\(consumer)/wash/\(bookingId)/damages/add",
                                     params: parameters,
                                     expectedResponseType: .object,
                                     multipartParams: multipartParams,
                                     responseHandler: { (response: ApiResponse) -> RequestResult<ApiObject, ApiErrorCategory<ApiDefaultError>> in
                                        return ResponseMapper.mapObjectResponse(response: response, type: ApiObject.self)
            })
            
            
            return request
        }
        
        static func updateDamageRequest(bookingId: String, damageId: String, parameters: [String: Any], image: UIImage?, consumer: String) -> ApiRequest<ApiObject, ApiErrorCategory<ApiDefaultError>> {
            var multipartParams : [String: Any] = [:]
            if let damageImage = image?.resizeImage(newWidth: 500) {
                if let data = UIImageJPEGRepresentation(damageImage, 0.5) {
                    multipartParams = ["damage[imageurl]": data]
                    
                }
            }
            let request = ApiRequest(httpMethod: .post,
                                     apiMethodName: "\(consumer)/wash/\(bookingId)/damages/update/\(damageId)",
                params: parameters,
                expectedResponseType: .object,
                 multipartParams: multipartParams,
                responseHandler: { (response: ApiResponse) -> RequestResult<ApiObject, ApiErrorCategory<ApiDefaultError>> in
                    return ResponseMapper.mapObjectResponse(response: response, type: ApiObject.self)
            })
            return request
        }
        
        public static func damagesListRequest(bookingId: String, consumer: String) -> ApiRequest<[Damage], ApiErrorCategory<ApiDefaultError>> {
            let request = ApiRequest(httpMethod: .get,
                                     apiMethodName: "\(consumer)/wash/\(bookingId)/damages/list",
                                     params: nil,
                                     expectedResponseType: .array,
                                     responseHandler: { (response: ApiResponse) -> RequestResult<[Damage], ApiErrorCategory<ApiDefaultError>> in
                                        return ResponseMapper.mapResponseArray(response: response, type: Damage.self)
            })
            return request
        }
        
        static func removeDamageRequest(bookingId: String, damageId: String, consumer: String) -> ApiRequest<ApiObject, ApiErrorCategory<ApiDefaultError>> {
            let request = ApiRequest(httpMethod: .get,
                                     apiMethodName: "\(consumer)/wash/\(bookingId)/damages/delete/\(damageId)",
                params: nil,
                expectedResponseType: .object,
                responseHandler: { (response: ApiResponse) -> RequestResult<ApiObject, ApiErrorCategory<ApiDefaultError>> in
                    return ResponseMapper.mapObjectResponse(response: response, type: ApiObject.self)
            })
            return request
        }
        
        static func washerSubmit(bookingId: String) -> ApiRequest<ApiObject, ApiErrorCategory<ApiDefaultError>> {
            let request = ApiRequest(httpMethod: .post,
                                     apiMethodName: "washer/wash/\(bookingId)/damages/submit",
                params: nil,
                expectedResponseType: .object,
                responseHandler: { (response: ApiResponse) -> RequestResult<ApiObject, ApiErrorCategory<ApiDefaultError>> in
                    return ResponseMapper.mapObjectResponse(response: response, type: ApiObject.self)
            })
            return request
        }
        static func userConfirmation(bookingId: String) -> ApiRequest<ApiObject, ApiErrorCategory<ApiDefaultError>> {
            let request = ApiRequest(httpMethod: .post,
                                     apiMethodName: "users/wash/\(bookingId)/confirmation",
                params: nil,
                expectedResponseType: .object,
                responseHandler: { (response: ApiResponse) -> RequestResult<ApiObject, ApiErrorCategory<ApiDefaultError>> in
                    return ResponseMapper.mapObjectResponse(response: response, type: ApiObject.self)
            })
            return request
        }
        static func startWash(bookingId: String) -> ApiRequest<ApiObject, ApiErrorCategory<ApiDefaultError>> {
            let request = ApiRequest(httpMethod: .post,
                                     apiMethodName: "washer/wash/\(bookingId)/start",
                params: nil,
                expectedResponseType: .object,
                responseHandler: { (response: ApiResponse) -> RequestResult<ApiObject, ApiErrorCategory<ApiDefaultError>> in
                    return ResponseMapper.mapObjectResponse(response: response, type: ApiObject.self)
            })
            return request
        }
    }
}

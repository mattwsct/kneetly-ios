//
//  ApiEndPoints+LookingForJob.swift
//  KneetlyWashersApp
//
//  Created by Matt Westcott on 01/02/2017.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import KneetlyCommon

extension ApiEndpoints {
    
    public struct LookingForJob {
        static func mobileWashOnlyRequest(latitude: Double, longitude: Double) -> ApiRequest<ApiObject, ApiErrorCategory<ApiDefaultError>> {
            let params = [ "latitude" : latitude,
                           "longitude" : longitude ]
            
            let request = ApiRequest(httpMethod: .post,
                                     apiMethodName: "washer/status/mobilewashonly",
                params: params,
                expectedResponseType: .object,
                responseHandler: { (response: ApiResponse) -> RequestResult<ApiObject, ApiErrorCategory<ApiDefaultError>> in
                    return ResponseMapper.mapObjectResponse(response: response, type: ApiObject.self)
            })
            return request
        }
        
        static func setWashLocationRequest(location: AddressedLocation, acceptMobile: Bool) -> ApiRequest<ApiObject, ApiErrorCategory<ApiDefaultError>> {
            var params = [ "latitude" : location.coordinate.latitude,
                           "longitude" : location.coordinate.longitude ]
                as [String : Any]
            
            if let address = location.address {
                params["address"] = address
            }
            
            let path = acceptMobile ? "washer/status/mobileandlocationwash" : "washer/status/locationwashonly"
            
            let request = ApiRequest(httpMethod: .post,
                                     apiMethodName: path,
                                     params: params,
                                     expectedResponseType: .object,
                                     responseHandler: { (response: ApiResponse) -> RequestResult<ApiObject, ApiErrorCategory<ApiDefaultError>> in
                                        return ResponseMapper.mapObjectResponse(response: response, type: ApiObject.self)
            })
            return request
        }
        
        static func goOfflineRequest() -> ApiRequest<ApiObject, ApiErrorCategory<ApiDefaultError>> {
            let request = ApiRequest(httpMethod: .post,
                                     apiMethodName: "washer/status/offline",
                                     params: nil,
                                     expectedResponseType: .object,
                                     responseHandler: { (response: ApiResponse) -> RequestResult<ApiObject, ApiErrorCategory<ApiDefaultError>> in
                                        return ResponseMapper.mapObjectResponse(response: response, type: ApiObject.self)
            })
            return request
        }
        
        static func confirmRequest(bookingId: String) -> ApiRequest<ApiObject, ApiErrorCategory<ApiDefaultError>> {
            let request = ApiRequest(httpMethod: .post,
                                     apiMethodName: "washer/wash/\(bookingId)/confirmation",
                                     params: nil,
                                     expectedResponseType: .object,
                                     responseHandler: { (response: ApiResponse) -> RequestResult<ApiObject, ApiErrorCategory<ApiDefaultError>> in
                                        return ResponseMapper.mapObjectResponse(response: response, type: ApiObject.self)
            })
            return request
        }
        
        static func rejectRequest(bookingId: String, categoriesId: String, comments: String) -> ApiRequest<ApiObject, ApiErrorCategory<ApiDefaultError>> {
            let params = ["categories_id": categoriesId, "comments": comments]
            let request = ApiRequest(httpMethod: .post,
                                     apiMethodName: "washer/wash/\(bookingId)/reject",
                params: params,
                expectedResponseType: .object,
                responseHandler: { (response: ApiResponse) -> RequestResult<ApiObject, ApiErrorCategory<ApiDefaultError>> in
                    return ResponseMapper.mapObjectResponse(response: response, type: ApiObject.self)
            })
            return request
        }
        
        static func cancellationCategoryRequest() -> ApiRequest<[CancellationCategory], ApiErrorCategory<ApiDefaultError>> {
            let request = ApiRequest(httpMethod: .get,
                                     apiMethodName: "washer/category/cancellation/list",
                                     params: nil,
                                     expectedResponseType: .array,
                                     responseHandler: { (response: ApiResponse) -> RequestResult<[CancellationCategory], ApiErrorCategory<ApiDefaultError>> in
                                        return ResponseMapper.mapResponseArray(response: response, type: CancellationCategory.self)
            })
            return request
        }

        public static func getBookingWash(id: String) -> ApiRequest<BookingWash, ApiErrorCategory<ApiDefaultError>> {
            return ApiRequest(
                httpMethod: .get,
                apiMethodName: "washer/wash/get/\(id)",
                params: nil,
                expectedResponseType: .object,
                responseHandler: { (response: ApiResponse) -> RequestResult<BookingWash, ApiErrorCategory<ApiDefaultError>> in
                    return ResponseMapper.mapObjectResponse(response: response, type: BookingWash.self)
            })
        }
        
        public static func getUser(id: String) -> ApiRequest<User, ApiErrorCategory<ApiDefaultError>> {
            return ApiRequest(
                httpMethod: .get,
                apiMethodName: "washer/users/get/\(id)",
                params: nil,
                expectedResponseType: .object,
                responseHandler: { (response: ApiResponse) -> RequestResult<User, ApiErrorCategory<ApiDefaultError>> in
                    return ResponseMapper.mapObjectResponse(response: response, type: User.self)
                }
            )
        }
    }
}

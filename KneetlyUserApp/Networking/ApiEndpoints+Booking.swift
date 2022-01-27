//
//  ApiEndpoints+Booking.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 1/13/17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import KneetlyCommon

extension ApiEndpoints {
    
    struct Booking {
        
        static func bookRequest(wash: Wash) -> ApiRequest<BookingResult, ApiErrorCategory<ApiDefaultError>> {
            var params = [ "vehicle_id" : wash.vehicleId!,
                           "washtype_id" : wash.washTypeId!,
                           "is_washer_come_to_me" : wash.locationType.rawValue ]
             as [String : Any]
            
            if let scheduledTime = wash.scheduledTime {
                params["scheduledtime"] = round(scheduledTime.timeIntervalSince1970)
            }
            if let washerId = wash.washerId {
                params["washer_id"] = washerId
            }
            
            let request = ApiRequest(httpMethod: .post,
                                     apiMethodName: "users/wash/add",
                                     params: params,
                                     expectedResponseType: .object,
                                     responseHandler: { (response: ApiResponse) -> RequestResult<BookingResult, ApiErrorCategory<ApiDefaultError>> in
                                        return ResponseMapper.mapObjectResponse(response: response, type: BookingResult.self)
            })
            return request
        }
        
        public static func getBooking(id: String) -> ApiRequest<BookingWash, ApiErrorCategory<ApiDefaultError>> {
            return ApiRequest(
                httpMethod: .get,
                apiMethodName: "users/wash/get/\(id)",
                params: nil,
                expectedResponseType: .object,
                responseHandler: { (response: ApiResponse) -> RequestResult<BookingWash, ApiErrorCategory<ApiDefaultError>> in
                    return ResponseMapper.mapObjectResponse(response: response, type: BookingWash.self)
                }
            )
        }
        
        static func setLocationRequest(bookingId: String, location: AddressedLocation, washerId: String? = nil) -> ApiRequest<ApiObject, ApiErrorCategory<ApiDefaultError>> {
            var params = [ "latitude" : location.coordinate.latitude,
                           "longitude" : location.coordinate.longitude ]
                as [String : Any]
            
            if let washerId = washerId {
                params["washer_id"] = washerId
            }
            
            if let address = location.address {
                params["address"] = address
            }
            
            let request = ApiRequest(httpMethod: .post,
                                     apiMethodName: "users/wash/\(bookingId)/location",
                                     params: params,
                                     expectedResponseType: .object,
                                     responseHandler: { (response: ApiResponse) -> RequestResult<ApiObject, ApiErrorCategory<ApiDefaultError>> in
                                        return ResponseMapper.mapObjectResponse(response: response, type: ApiObject.self)
            })
            return request
        }
        
        static func confirmRequest(bookingId: String) -> ApiRequest<ApiObject, ApiErrorCategory<ApiDefaultError>> {
            return ApiRequest(httpMethod: .post,
                              apiMethodName: "users/wash/\(bookingId)/confirm/washer",
                params: nil,
                expectedResponseType: .object) { (response: ApiResponse) -> RequestResult<ApiObject, ApiErrorCategory<ApiDefaultError>> in
                    return ResponseMapper.mapObjectResponse(response: response, type: ApiObject.self)
            }
        }

        static func cancelRequest(bookingId: String) -> ApiRequest<ApiObject, ApiErrorCategory<ApiDefaultError>> {
            return ApiRequest(httpMethod: .post,
                              apiMethodName: "users/wash/\(bookingId)/reject/washer",
                params: nil,
                expectedResponseType: .object) { (response: ApiResponse) -> RequestResult<ApiObject, ApiErrorCategory<ApiDefaultError>> in
                    return ResponseMapper.mapObjectResponse(response: response, type: ApiObject.self)
            }
        }
    }
}

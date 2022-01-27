//
//  ApiEndpoints+Vehicle.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott Dolzhikova on 18/01/2017.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import KneetlyCommon

extension ApiEndpoints {
    
    struct Vehicles {
        static func vehicleMakeRequest() -> ApiRequest<[VehicleMake], ApiErrorCategory<ApiDefaultError>> {
            let request = ApiRequest(httpMethod: .get,
                                     apiMethodName: "vehiclemake/list",
                                     params: nil,
                                     expectedResponseType: .array,
                                     responseHandler: { (response: ApiResponse) -> RequestResult<[VehicleMake], ApiErrorCategory<ApiDefaultError>> in
                                        return ResponseMapper.mapResponseArray(response: response, type: VehicleMake.self)
            })
            return request
        }
        
        static func vehicleModelRequest(makeId : String) -> ApiRequest<[VehicleModel], ApiErrorCategory<ApiDefaultError>> {
            let request = ApiRequest(httpMethod: .get,
                                     apiMethodName: "vehiclemake/\(makeId)/vehiclemodel/list",
                                     params: nil,
                                     expectedResponseType: .array,
                                     responseHandler: { (response: ApiResponse) -> RequestResult<[VehicleModel], ApiErrorCategory<ApiDefaultError>> in
                                        return ResponseMapper.mapResponseArray(response: response, type: VehicleModel.self)
            })
            return request
        }
        
        public static func addVehicle(parameters: [String: Any]) -> ApiRequest<ApiObject, ApiErrorCategory<ApiDefaultError>> {
            return ApiRequest(httpMethod: .post,
                              apiMethodName: "vehicle/add",
                              params: parameters,
                              expectedResponseType: .object,
                              responseHandler: { (response: ApiResponse) -> RequestResult<ApiObject, ApiErrorCategory<ApiDefaultError>> in
                                return ResponseMapper.mapObjectResponse(response: response, type: ApiObject.self)
            })
        }
        
        public static func vehicleListRequest() -> ApiRequest<[Vehicle], ApiErrorCategory<ApiDefaultError>> {
            let request = ApiRequest(httpMethod: .get,
                                     apiMethodName: "vehicle/list",
                params: nil,
                expectedResponseType: .array,
                responseHandler: { (response: ApiResponse) -> RequestResult<[Vehicle], ApiErrorCategory<ApiDefaultError>> in
                    return ResponseMapper.mapResponseArray(response: response, type: Vehicle.self)
            })
            return request
        }
        
        public static func removeRequest(vehicleId: String) -> ApiRequest<ApiObject, ApiErrorCategory<ApiDefaultError>> {
            return ApiRequest(httpMethod: .get,
                              apiMethodName: "vehicle/delete/\(vehicleId)",
                              params: nil,
                              expectedResponseType: .object,
                              responseHandler: { (response: ApiResponse) -> RequestResult<ApiObject, ApiErrorCategory<ApiDefaultError>> in
                                return ResponseMapper.mapObjectResponse(response: response, type: ApiObject.self)
            })
        }
        
        public static func updateRequest(vehicleId: String, parameters: [String:Any]) -> ApiRequest<ApiObject, ApiErrorCategory<ApiDefaultError>> {
            return ApiRequest(httpMethod: .post,
                              apiMethodName: "vehicle/update/\(vehicleId)",
                              params: parameters,
                              expectedResponseType: .object,
                              responseHandler: { (response: ApiResponse) -> RequestResult<ApiObject, ApiErrorCategory<ApiDefaultError>> in
                                return ResponseMapper.mapObjectResponse(response: response, type: ApiObject.self)
            })
        }
    }
    
}

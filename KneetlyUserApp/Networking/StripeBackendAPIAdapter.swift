//
//  StripeBackendAPIAdapter.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 24/01/2017.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import KneetlyCommon
import Stripe

class StripeBackendAPIAdapter: NSObject, STPBackendAPIAdapter {
    
    private var requestSender: RequestSender!
    
    private var businessId: String?
    
    init(requestSender: RequestSender, businessId: String? = nil) {
        self.requestSender = requestSender
        self.businessId = businessId
    }
    
    @objc public func retrieveCustomer(_ completion: @escaping STPCustomerCompletionBlock) {
        
        let path = "users/stripe/get"
        
        var params: [String: Any] = [:]
        
        if let businessId = businessId {
            params["business_id"] = businessId
        }
        
        let request = ApiRequest(httpMethod: .get, apiMethodName: path, params: params, expectedResponseType: .object) { (response: ApiResponse) -> RequestResult<[String: Any], ApiErrorCategory<ApiDefaultError>> in
            return ResponseMapper.mapJSONResponse(response: response, type: [String : Any].self)
        }
        
        requestSender.sendRequest(apiRequest: request, completion: { (result) in
            switch result {
            case .success(let customer):
                let deserializer = STPCustomerDeserializer(jsonResponse: customer)
                if let error = deserializer.error {
                    completion(nil, error)
                    return
                } else if let customer = deserializer.customer {
                    completion(customer, nil)
                }
            case .failure(let error):
                completion(nil, error.originalError)
            }
        })
    }
    
    @objc public func selectDefaultCustomerSource(_ source: STPSource, completion: @escaping STPErrorBlock) {
        
        let path = "users/stripe/source/default"
        
        var params = ["source_id" : source.stripeID]
        
        if let businessId = businessId {
            params["business_id"] = businessId
        }
        
        let request = ApiRequest(httpMethod: .post, apiMethodName: path, params: params, expectedResponseType: .object) { (response: ApiResponse) -> RequestResult<ApiObject, ApiErrorCategory<ApiDefaultError>> in
            return ResponseMapper.mapObjectResponse(response: response, type: ApiObject.self)
        }
        
        requestSender.sendRequest(apiRequest: request, completion: { (result) in
            switch result {
            case .success(_):
                completion(nil)
            case .failure(let error):
                completion(error.originalError)
            }
        })
    }
    
    @objc public func attachSource(toCustomer source: STPSource, completion: @escaping STPErrorBlock) {
        
        let path = "users/stripe/source/create"
        
        var params = ["source_id" : source.stripeID]
        
        if let businessId = businessId {
            params["business_id"] = businessId
        }
        
        let request = ApiRequest(httpMethod: .post, apiMethodName: path, params: params, expectedResponseType: .object) { (response: ApiResponse) -> RequestResult<ApiObject, ApiErrorCategory<ApiDefaultError>> in
            return ResponseMapper.mapObjectResponse(response: response, type: ApiObject.self)
        }
        
        requestSender.sendRequest(apiRequest: request, completion: { (result) in
            switch result {
            case .success(_):
                completion(nil)
            case .failure(let error):
                completion(error.originalError)
            }
        })
    }
}

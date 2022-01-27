//
//  ApiEndpoints+BankInformation.swift
//  KneetlyWashersApp
//
//  Created by Matt Westcott on 09.02.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import KneetlyCommon

extension ApiEndpoints {
    
    struct PaymentRequest {
        public static func getBankAccountInfo() -> ApiRequest<BankAccountInfo, ApiErrorCategory<ApiDefaultError>> {
            return ApiRequest(
                httpMethod: .get,
                apiMethodName: "washer/bankinformation/get",
                params: nil,
                expectedResponseType: .object,
                responseHandler: { (response: ApiResponse) -> RequestResult<BankAccountInfo, ApiErrorCategory<ApiDefaultError>> in
                    return ResponseMapper.mapObjectResponse(response: response, type: BankAccountInfo.self)
                }
            )
        }
        public static func updateBankAccountInfo(
            accountName: String,
            accountNumber: String,
            bsb: String,
            bank: String) -> ApiRequest<ApiObject, ApiErrorCategory<ApiDefaultError>> {
            return ApiRequest(
                httpMethod: .post,
                apiMethodName: "washer/bankinformation/update",
                params: ["account_name" : accountName, "account_number" : accountNumber, "bsb" : bsb, "bank" : bank],
                expectedResponseType: .object,
                responseHandler: { (response: ApiResponse) -> RequestResult<ApiObject, ApiErrorCategory<ApiDefaultError>> in
                    return ResponseMapper.mapObjectResponse(response: response, type: ApiObject.self)
                }
            )
        }
        public static func getPaymentHistory() -> ApiRequest<[WasherPayment], ApiErrorCategory<ApiDefaultError>>  {
            return ApiRequest(
                httpMethod: .get,
                apiMethodName: "washer/payment/get",
                params: nil,
                expectedResponseType: .array,
                responseHandler: { (response: ApiResponse) -> RequestResult<[WasherPayment], ApiErrorCategory<ApiDefaultError>> in
                    return ResponseMapper.mapResponseArray(response: response, type: WasherPayment.self)
                }
            )
        }
    }
}

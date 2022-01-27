import Foundation
import Alamofire
import AlamofireActivityLogger

public enum HTTPMethod {
    case post, get
}

typealias ObjectResponse = [String: Any]

public protocol ApiMappedObject {
    
}

public enum ResponseType {
    case object, array, text
    
    func isValid(response: Any) -> Bool {
        switch self {
        case .array: return response is [ObjectResponse]
        case .object: return response is ObjectResponse
        case .text: return response is String
        }
    }
}

public enum RequestResult<ResultType, ErrorType: RequestErrorType> {
    case success(ResultType), failure(RequestError<ErrorType>)
    
    public var error: RequestError<ErrorType>? {
        switch self {
        case .failure(let e):
            return e
        default:
            return nil
        }
    }
    
    public var value: ResultType? {
        switch self {
        case .success(let object): return object
        default: return nil
        }
    }
}

public struct RequestError<T> {
    public let type: T
    public let statusCode: Int?
    public let message: String?
    public let originalError: NSError?
}

public protocol RequestErrorType: Error {
 
}

public enum ApiResponse {
    case json(Any)
    case error(NSError?, Data?)
}

public struct ApiRequest <ResultType, ErrorType: RequestErrorType> {
    public let httpMethod: HTTPMethod
    public let apiMethodName: String
    public let params: [String: Any]?
    public let multipartParams: [String: Any]?
    public let expectedResponseType: ResponseType
    public let responseHandler: (ApiResponse) -> RequestResult<ResultType, ErrorType>
    
    public init (httpMethod: HTTPMethod,
                 apiMethodName: String,
                 params: [String: Any]?,
                 expectedResponseType: ResponseType,
                 multipartParams: [String: Any] = [:],
                 responseHandler: @escaping (ApiResponse) -> RequestResult<ResultType, ErrorType>) {
        self.httpMethod = httpMethod
        self.apiMethodName = apiMethodName
        self.params = params
        self.multipartParams = multipartParams
        self.expectedResponseType = expectedResponseType
        self.responseHandler = responseHandler
    }
}
 
public protocol RequestSender {
    func sendRequest<ResultType, ErrorType: RequestErrorType>(apiRequest: ApiRequest<ResultType, ErrorType>,
                     completion: ((RequestResult<ResultType, ErrorType>)->())?)
}

public class ApiClient: RequestSender {
    
    public let baseURL: String
    
    private let sessionManager = SessionManager()
    
    public var constantParameters: [String: Any]?
    
    public var errorStatusCodeForNotification: Int?
    
    public var didReceiveErrorStatusCodeHandler: ((Int)->())?
    
    public init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    public func sendRequest<ResultType, ErrorType: RequestErrorType>(apiRequest: ApiRequest<ResultType, ErrorType>,
                     completion: ((RequestResult<ResultType, ErrorType>)->())?) {
        
        let url = baseURL + apiRequest.apiMethodName
        let alamofireHTTPMethod: Alamofire.HTTPMethod
        switch apiRequest.httpMethod {
            case .post: alamofireHTTPMethod = .post
            case .get: alamofireHTTPMethod = .get
        }
        
        var params = apiRequest.params ?? [:]
        if let constantParameters = constantParameters {
            for (k,v) in constantParameters {
                params[k] = v
            }
        }
        if (apiRequest.multipartParams?.count)! > 0 {
                upload(multipartFormData: { (multipartFormData) in
                    for param in apiRequest.multipartParams! {
                        multipartFormData.append(param.value as! Data, withName: param.key, fileName: "\(param.key).jpg", mimeType: "image/jpg")
                    }
                    for param in params {
                        let string = "\(param.value)"
                        multipartFormData.append(string.data(using: String.Encoding.utf8)!, withName: param.key)
                    }
                    
                }, to: url , encodingCompletion: { result in
                    switch result {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            switch response.result {
                            case .success:
                                let result = apiRequest.responseHandler(.json(response.result.value!))
                                completion?(result)
                            case .failure(let error):
                                let result = apiRequest.responseHandler(.error(error as NSError, response.data))
                                if let codeForNotification = self.errorStatusCodeForNotification, result.error?.statusCode == codeForNotification {
                                    self.didReceiveErrorStatusCodeHandler?(codeForNotification)
                                }
                                completion?(result)
                            }
                        }
                        .log()
                        break
                    case .failure(let error): break
                        let result = apiRequest.responseHandler(.error(error as NSError, nil))
                        completion?(result)
                    }
                })
        } else {
            request(url, method: alamofireHTTPMethod, parameters: params).validate().responseJSON { (response) in
                switch response.result {
                case .success:
                    let result = apiRequest.responseHandler(.json(response.result.value!))
                    completion?(result)
                case .failure(let error):
                    let result = apiRequest.responseHandler(.error(error as NSError, response.data))
                    if let codeForNotification = self.errorStatusCodeForNotification, result.error?.statusCode == codeForNotification {
                        self.didReceiveErrorStatusCodeHandler?(codeForNotification)
                    }
                    completion?(result)
                }
            }
            .log()
        }
    }
}

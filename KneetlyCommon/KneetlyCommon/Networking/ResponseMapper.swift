import Foundation
import ObjectMapper

public class ResponseMapper {
 
    public static func mapResponseArray<T: ApiObject, U: RequestErrorType>(response: ApiResponse, type: T.Type) -> RequestResult<[T], ApiErrorCategory<U>> {
        switch response {
        case .error(let error, let data):
            return .failure(makeRequestError(withData: data, error: error))
        case .json(let json):
            guard ResponseType.array.isValid(response: json) else {
                return .failure(RequestError(type: ApiErrorCategory<U>.common(.invalidReponseFormat), statusCode: nil, message: nil, originalError: nil))
            }
            
            let result = Mapper<T>().mapArray(JSONObject: json as! [ObjectResponse])
            return .success(result ?? [])
        }
    }
    
    public static func mapObjectResponse<T: ApiObject, U: RequestErrorType>(response: ApiResponse, type: T.Type) -> RequestResult<T, ApiErrorCategory<U>> {
        switch response {
        case .error(let error, let data):
            return .failure(makeRequestError(withData: data, error: error))
        case .json(let json):
            
            guard ResponseType.object.isValid(response: json) else {
                return .failure(RequestError(type: ApiErrorCategory<U>.common(.invalidReponseFormat), statusCode: nil, message: nil, originalError: nil))
            }
            
            guard let result =  Mapper<T>().map(JSON: json as! ObjectResponse) else {
                return .failure(RequestError(type: ApiErrorCategory<U>.common(.invalidReponseFormat), statusCode: nil, message: nil, originalError: nil))
            }
            
            return .success(result)
        }
    }
    
    public static func mapJSONResponse<U: RequestErrorType>(response: ApiResponse, type: [String: Any].Type) -> RequestResult<[String: Any], ApiErrorCategory<U>> {
        switch response {
        case .error(let error, let data):
            return .failure(makeRequestError(withData: data, error: error))
        case .json(let json):
            
            guard ResponseType.object.isValid(response: json) else {
                return .failure(RequestError(type: ApiErrorCategory<U>.common(.invalidReponseFormat), statusCode: nil, message: nil, originalError: nil))
            }
            
            guard let result = json as? ObjectResponse else {
                return .failure(RequestError(type: ApiErrorCategory<U>.common(.invalidReponseFormat), statusCode: nil, message: nil, originalError: nil))
            }
            
            return .success(result)
        }
    }
    
    private static func makeRequestError<U: RequestErrorType>(withData data: Data?, error: NSError?) -> RequestError<ApiErrorCategory<U>> {
        if let codeAndMessage = codeAndMessage(fromData: data) {
            if let type = ApiErrorCategory<U>.from(code: codeAndMessage.0) {
                let requestError = RequestError<ApiErrorCategory<U>>(type: type, statusCode: codeAndMessage.0, message: codeAndMessage.1, originalError: error)
                return requestError
            }
            else {
                return RequestError(type: ApiErrorCategory<U>.common(.unknown), statusCode: codeAndMessage.0, message: codeAndMessage.1, originalError: error)
            }
        }
        else  if let error = error, error.isConnectionError() {
            let category = ApiErrorCategory<U>.system(.noConnection)
            return RequestError(type: category, statusCode: nil, message: nil, originalError: error)
        }
        else {
            let category = ApiErrorCategory<U>.common(.unknown)
            return RequestError(type: category, statusCode: nil, message: nil, originalError: error)
        }
    }
 
    private static func codeAndMessage(fromData data: Data?) -> (Int, String)? {
        guard let data = data else {
            return nil
        }
        
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? ObjectResponse else { return nil}
            guard let message = json["error_description"] as? String, let code = json["error"] as? Int else { return nil }
            return (code, message)
        }
        catch {
            return nil
        }
    }
}

extension NSError {
    func isConnectionError() -> Bool {
        guard domain == NSURLErrorDomain else {
            return false
        }
        return code == NSURLErrorNetworkConnectionLost || code == NSURLErrorNotConnectedToInternet
    }
}


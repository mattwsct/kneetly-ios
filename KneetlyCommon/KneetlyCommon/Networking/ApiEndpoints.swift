import Foundation
import ObjectMapper

let ApiErrorDomain = "api.kneetly"

public enum ApiErrorCategory<T:RequestUniqueErrorType>: RequestErrorType {
    case request(T)
    case common(ApiCommonError)
    case system(SystemError)
    
    public static func from(code: Int) -> ApiErrorCategory? {
        if let requestErrorType = T.from(code: code)  {
            return ApiErrorCategory<T>.request(requestErrorType)
        }
        if let commonErrorType = ApiCommonError.from(code: code)  {
            return ApiErrorCategory<T>.common(commonErrorType)
        }
        
        return nil
    }
    
    public var isNoConnectionError: Bool {
        switch self {
        case .system(let type):
            switch type {
            case .noConnection: return true
            default: return false
        }
        default:
            return false
        }
    }
}

extension RequestErrorType {
    static func from(code: Int) -> Self? {
        return nil
    }
}

public protocol RequestUniqueErrorType: RequestErrorType {
    static func errorByCode() -> [ApiErrorCode: Self]
}

extension RequestUniqueErrorType {
    static func from(code: Int) -> Self? {
        guard let apiCode = ApiErrorCode(rawValue: code) else {
            return nil
        }
        return errorByCode()[apiCode]
    }
    
    public static func errorByCode() -> [ApiErrorCode: Self] {
        return [:]
    }
}

public enum ApiCommonError: RequestErrorType {
    case invalidToken
    case invalidReponseFormat
    case unknown
}

public enum SystemError {
    case noConnection
}

public enum ApiDefaultError: RequestUniqueErrorType { }
public enum ApiLoginError: RequestUniqueErrorType { }
public enum ApiRegisterError: RequestUniqueErrorType { }

public struct ApiEndpoints {
  
    
}

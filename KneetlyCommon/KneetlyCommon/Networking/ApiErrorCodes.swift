import Foundation

public enum ApiErrorCode: Int {
    case firebaseTokenError = 1
    case userAlreadyExists =  2
    case invalidClientID = 3
    case unknownGrantType = 4
    case dateFormatError =  5
    case missingRequiredParameter  = 6
    case invalidRequiredParameter = 7
    case resourceNotFound =  8
    case duplicateEntry = 9
    case unauthorized = 10
    case userNotFound =  11
    case invalidAccessToken = 12
    case washerAlreadyAttached = 32
}

import Foundation
import ObjectMapper

 
///This class is used as base class for all classes that represent data from server
open class ApiObject: Mappable, ApiMappedObject {
    
    init() {}
    
    required public init?(map: Map) {
        guard validate(map: map) else {
            return nil
        }
    }
    
    private func validate(map: Map) -> Bool {
        let keys = requiredKeys()
        for key in keys {
            guard map.JSON[key] != nil else {
                return false
            }
        }
        return true
    }

    public func mapping(map: Map) {
        mapObject(map: map)
    }
    
    ///Update object with JSON Data. Subclasses should override this method to implement custom mapping
    open func mapObject(map: Map) {
        
    }
    
    ///Returns required keys in response. Should be used only by subclasses.
    open func requiredKeys() -> [String] {
        return []
    }
}

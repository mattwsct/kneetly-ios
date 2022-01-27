//
//  DataSource.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 26/12/2016.
//  Copyright © 2016 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation

public enum DataSourceState {
    case initial
    case noData
    case loading
    case loaded
    case failed(RequestError<ApiErrorCategory<ApiDefaultError>>)
    
    var isUpdateBlockingState: Bool {
        switch self {
        case .loading: return true
        default: return false
        }
    }
}

protocol ContentAvailability {
    func hasContent() -> Bool
}


extension ContentAvailability  {
    func hasContent() -> Bool {
        return false
    }
}

open class DataSource<DataType>: ContentAvailability {
    var state: DataSourceState = .initial
    private var requestSender: RequestSender!
    private var apiRequest: ApiRequest<DataType, ApiErrorCategory<ApiDefaultError>>
    fileprivate fileprivate(set) var content: DataType?
    
    public var onStateUpdated : (_ dataSource: DataSource, _ state: DataSourceState) -> Void =  {_ in }
    
    public init(requestSender: RequestSender, apiRequest: ApiRequest<DataType, ApiErrorCategory<ApiDefaultError>>) {
        self.requestSender = requestSender
        self.apiRequest = apiRequest
    }
    
    private func updateState(state: DataSourceState) {
        self.state = state
        self.onStateUpdated(self, self.state)
    }
    
    public func reload() {
        reload(withCompletion: nil)
    }
    
    public func reload(withCompletion completion: (()->())?){
        guard !state.isUpdateBlockingState else {
            return
        }
        
        updateState(state: .loading)
        
        self.requestSender?.sendRequest(apiRequest: self.apiRequest, completion: { (requestResult) in
            switch requestResult {
            case .success(let result):
                self.content = result
                self.updateState(state: .loaded)
            case .failure(let error):
                self.updateState(state: .failed(error))
            }
            
            self.updateState(state: self.hasContent() ? .loaded : .noData)
            
            completion?()
        })
    }
}

extension DataSource where DataType: RandomAccessCollection {
    public var items: DataType? {
        return content
    }
    
    func hasContent() -> Bool {
        guard let items = items else {
            return false
        }
        return items.count > 0
    }
}

extension DataSource where DataType: ApiMappedObject {
    public var object: DataType? {
        return content
    }
    
    func hasContent() -> Bool {
        return object != nil
    }
}


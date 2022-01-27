//
//  WatchedVideoTracker.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 2/8/17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation

public class WatchedVideoTracker {
    
    private let requestSender: RequestSender
    
    private let markAsWatchedRequestProvider: (String)->(ApiRequest<ApiObject, ApiErrorCategory<ApiDefaultError>>)
    
    public init(requestSender: RequestSender, markAsWatchedRequestProvider: @escaping (String)->(ApiRequest<ApiObject, ApiErrorCategory<ApiDefaultError>>)) {
        self.requestSender = requestSender
        self.markAsWatchedRequestProvider = markAsWatchedRequestProvider
    }
    
    public func markVideoAsWatched(videoId: String, completion: ((Bool)->())?) {
        let request = markAsWatchedRequestProvider(videoId)
        requestSender.sendRequest(apiRequest: request) { (response) in
             completion?(response.value != nil)
        }
    }
    
}

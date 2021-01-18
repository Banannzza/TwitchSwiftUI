//
//  StreamsMethod.swift
//  TwitchApi
//
//  Created by adostapenko on 11.01.2021.
//

import Foundation

struct StreamsMethod: ApiMethod {
    let response = BackendArray<StreamInfo>.self
    let authorized: Bool = true
    let method: HTTPMethod = .get
    let params: [String : String] = [:]
    let host = "https://api.twitch.tv/helix/streams"
    let userIds: [String]
    
    init(userIds: [String]) {
        self.userIds = userIds
    }
    
    var queryParams: String {
        userIds.map { "user_id=\($0)" }.joined(separator: "&")
    }
}

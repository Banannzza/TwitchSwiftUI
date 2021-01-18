//
//  EmoteMethod.swift
//  Twitch
//
//  Created by Aleksey Ostapenko on 17.01.2021.
//

import Foundation

struct EmoteMethod: ApiMethod {
    enum EmoteSize: String {
        case one = "1.0"
        case two = "2.0"
        case three = "3.0"
    }
    
    let response = Data.self
    let authorized: Bool = false
    let method: HTTPMethod = .get
    let params: [String : String] = [:]
    let id: String
    let size: EmoteSize
    
    init(id: String, size: EmoteSize = .one) {
        self.id = id
        self.size = size
    }
    
    var host: String {
        "https://static-cdn.jtvnw.net/emoticons/v1/\(id)/\(size.rawValue)"
    }
}

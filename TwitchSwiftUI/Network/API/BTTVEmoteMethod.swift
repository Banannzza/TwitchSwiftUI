//
//  BTTVEmoteMethod.swift
//  Twitch
//
//  Created by Aleksey Ostapenko on 17.01.2021.
//

import Foundation

struct BTTVEmoteMethod: ApiMethod {
    enum Size: String {
        case small = "1x"
        case medium = "2x"
        case large = "3x"
    }
    
    let response = Data.self
    let authorized: Bool = false
    let method: HTTPMethod = .get
    let params: [String : String] = [:]
    let emoteID: String
    let size: Size
    
    init(emoteID: String, size: Size) {
        self.emoteID = emoteID
        self.size = size
    }
    
    var host: String {
        "https://cdn.betterttv.net/emote/\(emoteID)/\(size.rawValue)"
    }
}

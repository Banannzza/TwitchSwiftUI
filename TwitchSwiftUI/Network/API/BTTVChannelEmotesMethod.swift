//
//  BTTVChannelEmotesMethod.swift
//  Twitch
//
//  Created by Aleksey Ostapenko on 17.01.2021.
//

import Foundation

struct BTTVChannelEmotesMethod: ApiMethod {
    let response = BTTVChannelEmotes.self
    let authorized: Bool = false
    let method: HTTPMethod = .get
    let params: [String : String] = [:]
    let channelID: String
    
    init(channelID: String) {
        self.channelID = channelID
    }
    
    var host: String {
        "https://api.betterttv.net/3/cached/users/twitch/\(channelID)"
    }
}

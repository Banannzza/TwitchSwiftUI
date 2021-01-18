//
//  BTTVGlobalEmotesMethod.swift
//  Twitch
//
//  Created by Aleksey Ostapenko on 17.01.2021.
//

import Foundation

struct BTTVGlobalEmotesMethod: ApiMethod {
    let response = [BTTVEmote].self
    let authorized: Bool = false
    let method: HTTPMethod = .get
    let params: [String : String] = [:]
    let host = "https://api.betterttv.net/3/cached/emotes/global"
}

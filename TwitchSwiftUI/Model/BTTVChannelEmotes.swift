//
//  BTTVChannelEmotes.swift
//  Twitch
//
//  Created by Aleksey Ostapenko on 17.01.2021.
//

import Foundation

struct BTTVEmote: Decodable {
    enum ImageType: String, Decodable {
        case gif
        case png
    }
    
    let id: String
    let code: String
    let imageType: ImageType
}

struct BTTVChannelEmotes: Decodable {
    let shared: [BTTVEmote]
    let channel: [BTTVEmote]
    
    enum CodingKeys: String, CodingKey {
        case shared = "sharedEmotes"
        case channel = "channelEmotes"
    }
}

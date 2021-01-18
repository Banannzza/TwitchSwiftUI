//
//  Stream.swift
//  TwitchApi
//
//  Created by adostapenko on 11.01.2021.
//

import Foundation

struct StreamInfo: Decodable, Identifiable, Equatable {
    let id: String
    let userId: String
    let username: String
    let title: String
    let language: String
    let thumbnail: ThumnbnailURL
    let gameName: String
    
    enum DecodeError: Error {
        case invalidThumbnail
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case username = "user_name"
        case title
        case language
        case thumbnail = "thumbnail_url"
        case gameName = "game_name"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        userId = try container.decode(String.self, forKey: .userId)
        username = try container.decode(String.self, forKey: .username)
        title = try container.decode(String.self, forKey: .title)
        language = try container.decode(String.self, forKey: .language)
        gameName = try container.decode(String.self, forKey: .gameName)
        
        guard
            let thumbnail = ThumnbnailURL(try container.decode(String.self, forKey: .thumbnail))
            else { throw DecodeError.invalidThumbnail }
        self.thumbnail = thumbnail
    }
    
    init() {
        id = "stream_1"
        userId = "user_id"
        username = "username"
        title = "title"
        language = "ru"
        gameName = "IRL"
        thumbnail = ThumnbnailURL("https://static-cdn.jtvnw.net/previews-ttv/live_user_welovegames-{width}x{height}.jpg")!
    }
}

//
//  UserFollow.swift
//  Twitch
//
//  Created by Aleksey Ostapenko on 14.01.2021.
//

import Foundation

struct UserFollow: Decodable {
    let fromId: String
    let fromName: String
    let toId: String
    let toName: String
    let followedAt: String
    
    enum CodingKeys: String, CodingKey {
        case fromId = "from_id"
        case fromName = "from_name"
        case toId = "to_id"
        case toName = "to_name"
        case followedAt = "followed_at"
    }
}

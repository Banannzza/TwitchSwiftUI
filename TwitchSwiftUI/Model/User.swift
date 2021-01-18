//
//  User.swift
//  Twitch
//
//  Created by Aleksey Ostapenko on 14.01.2021.
//

import Foundation

struct User: Decodable, Identifiable, Equatable {
    let id: String
    let displayName: String
    let type: UserType
    let profileURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case id
        case displayName = "display_name"
        case type
        case profileURL = "profile_image_url"
    }
}

//
//  UserFollowInfo.swift
//  Twitch
//
//  Created by Aleksey Ostapenko on 14.01.2021.
//

import Foundation

struct UserFollowInfo: Decodable {
    let total: Int
    let data: [UserFollow]
}

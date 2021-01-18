//
//  FollowMethod.swift
//  Twitch
//
//  Created by Aleksey Ostapenko on 14.01.2021.
//

import Foundation

struct FollowsMethod: ApiMethod {
    let response = UserFollowInfo.self
    let authorized = true
    let method: HTTPMethod = .get
    let params: [String : String]
    let host = "https://api.twitch.tv/helix/users/follows"
        
    init(from userID: String) {
        params = ["from_id": userID]
    }
    
    init(to userID: String) {
        params = ["to_id": userID]
    }
}

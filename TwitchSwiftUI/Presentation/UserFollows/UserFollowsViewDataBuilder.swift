//
//  UserFollowsViewDataBuilder.swift
//  Twitch
//
//  Created by Aleksey Ostapenko on 14.01.2021.
//

import Foundation

struct UserFollowsViewData {
    
    struct OnlineUser: Identifiable {
        var id: String {
            user.id
        }
        
        let user: User
        let stream: StreamInfo
    }
    
    typealias OfflineUser = User
    
    let onlineUsers: [OnlineUser]
    let offlineUsers: [OfflineUser]
}

struct UserFollowsViewDataBuilder {
    func transform(onlineStreams: [StreamInfo], users: [User]) -> UserFollowsViewData {
        var onlineUsers = [UserFollowsViewData.OnlineUser]()
        var offlineUsers = [UserFollowsViewData.OfflineUser]()
        users.forEach { user  in
            if let stream = onlineStreams.first(where: { $0.userId == user.id }) {
                onlineUsers.append(.init(user: user, stream: stream))
            } else {
                offlineUsers.append(user)
            }
        }
        
        return UserFollowsViewData(onlineUsers: onlineUsers, offlineUsers: offlineUsers)
    }
}

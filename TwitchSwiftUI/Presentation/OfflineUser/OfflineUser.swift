//
//  OfflineUser.swift
//  Twitch
//
//  Created by Aleksey Ostapenko on 14.01.2021.
//

import SwiftUI

struct OfflineUser: View {
    let user: User
    
    var profilePlaceholder: some View {
        Image(systemName: "person.circle")
            .resizable()
    }
    
    @ViewBuilder func profileImage(_ user: User) -> some View {
        if let profileURL = user.profileURL {
            AsyncImage(profileURL)
                .clipShape(Circle())
        } else {
            Color.clear
        }
    }
    
    var body: some View {
        HStack {
            profileImage(user)
                .frame(width: 40, height: 40)
            Text(user.displayName)
                .font(.title3)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct OfflineUserFollows_Previews: PreviewProvider {
    static var previews: some View {
        OfflineUser(user: user)
    }
}

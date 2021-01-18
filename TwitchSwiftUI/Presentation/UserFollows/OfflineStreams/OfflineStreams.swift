//
//  OfflineStreams.swift
//  Twitch
//
//  Created by Aleksey Ostapenko on 16.01.2021.
//

import SwiftUI

struct OfflineStreams: View {
    let users: [User]
    
    func sectionTitle(_ title: String) -> some View {
        Text(title)
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical)
    }
    
    var body: some View {
        Section(header: sectionTitle("Offline")) {
            LazyVStack {
                ForEach(users) { user in
                    OfflineUser(user: user)
                }
            }
        }
    }
}

struct OfflineStreams_Previews: PreviewProvider {
    static var previews: some View {
        OfflineStreams(users: [])
    }
}

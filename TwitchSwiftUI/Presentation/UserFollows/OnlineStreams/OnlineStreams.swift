//
//  OnlineStreams.swift
//  Twitch
//
//  Created by Aleksey Ostapenko on 16.01.2021.
//

import SwiftUI



struct OnlineStreams: View {
    typealias Element = UserFollowsViewData.OnlineUser
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    @EnvironmentObject var appState: AppState
    let streams: [Element]
    
    func sectionTitle(_ title: String) -> some View {
        Text(title)
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical)
    }
    
    func onlineStreams(_ onlineStreams: [Element]) -> some View {
        ForEach(onlineStreams) { onlineStream in
            OnlineStream(user: onlineStream.user, stream: onlineStream.stream)
                .onTapGesture {
                    appState.selectedStream = onlineStream.stream
                }
        }
    }
    
    var body: some View {
        if streams.isNotEmpty {
            Section(header: sectionTitle("Online")) {
                if horizontalSizeClass == .some(.compact) {
                    LazyVStack {
                        onlineStreams(streams)
                    }
                } else if horizontalSizeClass == .some(UserInterfaceSizeClass.regular) {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                        onlineStreams(streams)
                    }
                }
            }
            
        } else {
            EmptyView()
        }
    }
}

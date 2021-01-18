//
//  UserFollows.swift
//  Twitch
//
//  Created by Aleksey Ostapenko on 14.01.2021.
//

import SwiftUI

struct UserFollows: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    @Environment(\.user) var user
    @Environment(\.networkClient) var networkClient: NetworkClient
    @EnvironmentObject var appState: AppState
    @StateObject var viewModel = UserFollowsViewModel()
    
    
    @ViewBuilder var content: some View {
        if let viewData = viewModel.viewData {
            ScrollView(.vertical, showsIndicators: false) {
                OnlineStreams(streams: viewData.onlineUsers)
                OfflineStreams(users: viewData.offlineUsers)
            }
        } else {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
        }
    }
    
    var body: some View {
        content
            .padding(.horizontal)
            .onAppear {
                viewModel.load(network: networkClient, for: user)
            }
            .fullScreenCover(item: $appState.selectedStream) { streamInfo in
                StreamViewer(streamInfo: streamInfo)
            }
    }
}

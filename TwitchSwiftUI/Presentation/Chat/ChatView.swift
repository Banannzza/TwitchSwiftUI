//
//  ChatView.swift
//  TwitchChat
//
//  Created by Aleksey Ostapenko on 03.01.2021.
//

import SwiftUI
import Combine

struct ChatView: View {
    @StateObject var viewModel = ChatViewModel()
    @Environment(\.networkClient) var networkClient
    @EnvironmentObject var appState: AppState
    @AppStorage(.token) var token
    
    let channel: String
    let channelId: String
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView(.vertical) {
                ScrollViewReader { reader in
                    LazyVStack(alignment: .leading) {
                        ForEach(viewModel.messages) { message in
                            ChatMessageView(message, maxWidth: proxy.size.width)
                        }
                    }
                    .onAppear {
                        viewModel.lastMessagePublisher { message in
                            reader.scrollTo(message.id, anchor: nil)
                        }
                    }
                }
            }
        }
        .clipped()
        .onAppear {
            guard let user = appState.user, let token = token else { return }
            viewModel.connect(to: channel, for: user, with: token)
            viewModel.load(networkClient: networkClient, for: channelId)
        }
        .onDisappear {
            viewModel.clear()
        }
    }
}

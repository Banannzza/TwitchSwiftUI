//
//  StreamViewer.swift
//  Twitch
//
//  Created by Aleksey Ostapenko on 16.01.2021.
//

import SwiftUI

struct StreamViewer: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appState: AppState
    
    let streamInfo: StreamInfo
    
    var isCompact: Bool {
        horizontalSizeClass == .some(.compact)
    }
    
    @ViewBuilder var content: some View {
        if isCompact {
            VStack {
                WebVideoPlayer(streamInfo: streamInfo)
                    .aspectRatio(16 / 9, contentMode: .fit)
                ChatView(channel: streamInfo.username, channelId: streamInfo.userId)
            }
        } else {
            GeometryReader { proxy in
                ZStack {
                    WebVideoPlayer(streamInfo: streamInfo)
                        .aspectRatio(16 / 9, contentMode: .fit)
                    HStack {
                        Spacer()
                        ChatView(channel: streamInfo.username, channelId: streamInfo.userId)
                            .background(Color.black.opacity(0.3))
                            .frame(width: proxy.size.width * 0.3)
                    }
                }
            }
        }
    }
    
    var body: some View {
        content
            .gesture(
                DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
                    .onEnded { value in
                        if value.translation.height > 0 && value.translation.width < 100 && value.translation.width > -100 {
                            print("down swipe")
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
            )
    }
}

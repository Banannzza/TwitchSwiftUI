//
//  WebVideoPlayer.swift
//  Twitch
//
//  Created by Aleksey Ostapenko on 16.01.2021.
//

import SwiftUI
import Combine

struct WebVideoPlayer: View {
    let streamInfo: StreamInfo
    @StateObject var viewModel = WebVideoPlayerViewModel()
    @State var isFillMode: Bool = false
    @State var sizeClassPublisher: AnyCancellable?
    
    init(streamInfo: StreamInfo) {
        self.streamInfo = streamInfo
    }
    
    var controls: some View {
        WebVideoControls(
            isMuted: $viewModel.isMuted,
            isPaused: $viewModel.isPaused,
            onPipTap: { viewModel.pipRequest() },
            onAirplayTap: { viewModel.airplayRequest() },
            onFullscreenTap: { /*viewModel.enterFullscreen()*/ }
        )
    }
    
    var clearTapableColor: Color {
        Color(red: 0, green: 0, blue: 0, opacity: 0.01)
    }
    
    var body: some View {
        ZStack {
            WebVideo(streamerName: streamInfo.username, webDelegate: WebVideoNavgation($viewModel.webView))
                .zIndex(0)
                .allowsHitTesting(false)
                .disabled(true)
            clearTapableColor
                .zIndex(1)
                .onTapGesture {
                    viewModel.showControls()
                }
            if !viewModel.controlsHidden {
                controls
                    .zIndex(2)
                    .transition(AnyTransition.opacity.animation(.linear))
            }
        }
    }
}

//struct WebVideoPlayer_Previews: PreviewProvider {
//    static var previews: some View {
//        WebVideoPlayer()
//    }
//}

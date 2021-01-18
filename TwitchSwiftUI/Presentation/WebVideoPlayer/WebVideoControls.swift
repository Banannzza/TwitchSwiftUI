//
//  WebVideoControls.swift
//  Twitch
//
//  Created by Aleksey Ostapenko on 16.01.2021.
//

import SwiftUI

struct WebVideoControls: View {
    
    @Binding var isMuted: Bool
    @Binding var isPaused: Bool
    
    var onPipTap: () -> ()
    var onAirplayTap: () -> ()
    var onFullscreenTap: () -> ()
    
    func contentShapePath(width: CGFloat, height: CGFloat) -> Path {
        Path(CGRect(origin: CGPoint(x: -width / 2, y: -height / 2), size: CGSize(width: width, height: height)))
    }
    
    var speakerButton: some View {
        (isMuted ? Image(systemName: "speaker.fill") : Image(systemName: "speaker.wave.3.fill"))
            .frame(width: 30, height: 30)
            .contentShape(Rectangle())
            .onTapGesture { isMuted.toggle()  }
    }
    
    var fullscreenButton: some View {
        Image(systemName: "iphone.landscape")
            .font(.system(size: 23.5))
            .frame(width: 30, height: 30)
            .contentShape(Rectangle())
            .onTapGesture { onFullscreenTap() }
    }
    
    var playButton: some View {
        (isPaused ? Image(systemName: "play.fill") : Image(systemName: "pause.fill"))
            .font(.system(size: 40))
            .contentShape(Rectangle())
            .onTapGesture { isPaused.toggle() }
    }
    
    var airPlayButton: some View {
        Image(systemName: "airplayvideo")
            .font(.system(size: 17))
            .frame(width: 30, height: 30)
            .contentShape(Rectangle())
            .onTapGesture { onAirplayTap() }
    }
    
    var pipButton: some View {
        Image(systemName: "pip")
            .font(.system(size: 15.8))
            .frame(width: 30, height: 30)
            .contentShape(Rectangle())
            .onTapGesture { onPipTap() }
    }

    var body: some View {
        ZStack {
            VStack {
                HStack(spacing: 10) {
                    Spacer()
                    airPlayButton
                    pipButton
                }
                Spacer()
            }
            playButton
            VStack {
                Spacer()
                HStack {
                    speakerButton
                    Spacer()
                    fullscreenButton
                }
            }
        }
        .foregroundColor(.white)
        .padding(16)
    }
}

//
//struct WebVideoControls_Previews: PreviewProvider {
//    static var previews: some View {
//        WebVideoControls()
//    }
//}

//
//  VideoPlayerJavaScriptor.swift
//  Twitch
//
//  Created by Aleksey Ostapenko on 16.01.2021.
//

import Foundation

struct VideoPlayerJavaScriptor {
    let element = "document.getElementsByTagName('video')[0]"
    
    func setMuted(_ isMuted: Bool) -> String {
        "\(element).muted=\(isMuted);"
    }
    
    func setPaused(_ isPaused: Bool) -> String {
        isPaused ? "\(element).pause();" : "\(element).play();"
    }
    
    func pipRequest() -> String {
        "\(element).webkitSetPresentationMode(\(element).webkitPresentationMode === 'picture-in-picture' ? 'inline' : 'picture-in-picture');"
    }
    
    func airplayRequest() -> String {
        "\(element).webkitShowPlaybackTargetPicker();"
    }
    
    func hideDefaultPlayer() -> String {
        "document.getElementsByClassName(\"video-player__default-player\")[0].parentNode.removeChild(document.getElementsByClassName(\"video-player__default-player\")[0]);"
    }
    
    func enterFullscreen() -> String {
        "\(element).webkitEnterFullscreen();"
    }
}

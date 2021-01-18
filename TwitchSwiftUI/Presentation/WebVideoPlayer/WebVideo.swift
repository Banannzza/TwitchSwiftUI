//
//  WebVideo.swift
//  Twitch
//
//  Created by Aleksey Ostapenko on 15.01.2021.
//

import SwiftUI
import WebKit

struct WebVideo: View {
    func request(for streamer: String) -> URLRequest {
        URLRequest(url: URL(string: "https://player.twitch.tv/?channel=\(streamer)&controls=false&html5&parent=localhost")!)
    }
    
    let streamerName: String
    let webDelegate: WebNavigationDelegate?
    
    var body: some View {
        Web(request: request(for: streamerName), delegate: webDelegate)
    }
}

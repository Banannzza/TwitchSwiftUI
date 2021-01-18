//
//  ChatMessageView.swift
//  TwitchChat (iOS)
//
//  Created by Aleksey Ostapenko on 03.01.2021.
//

import SwiftUI

struct ChatMessageView: View {
    let message: ChatMessage
    let maxWidth: CGFloat
    
    init(_ message: ChatMessage, maxWidth: CGFloat) {
        self.message = message
        self.maxWidth = maxWidth
    }
    
    @ViewBuilder func view(for component: ChatMessage.Component) -> some View {
        switch component {
        case let .sender(name, color):
            Text(name)
                .foregroundColor(color)
        case .image(let data):
            UIImage(data: data).flatMap { Image(uiImage: $0).frame(width: 28, height: 28) }
        case .gif(let data):
            GIF(data)
                .frame(width: 28, height: 28)
        case .text(let text):
            Text(text)
        }
    }
    
    var body: some View {
        ZContainer(maxWidth: maxWidth, message.components) { component in
            view(for: component)
        }
    }
}

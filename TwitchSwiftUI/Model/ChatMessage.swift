//
//  ChatMessage.swift
//  Twitch
//
//  Created by Aleksey Ostapenko on 17.01.2021.
//

import SwiftUI

struct ChatMessage: Identifiable, Hashable {
    enum Component: Hashable {
        case sender(String, Color)
        case text(String)
        case image(Data)
        case gif(Data)
    }
    
    let id = UUID()
    let components: [Component]
    
    static func == (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
        lhs.id == rhs.id
    }
}


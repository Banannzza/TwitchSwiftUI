//
//  SocketChatMessage.swift
//  Twitch
//
//  Created by Aleksey Ostapenko on 18.01.2021.
//

import Foundation

struct SocketChatMessage {
    enum Component {
        case text(String)
        case emote(id: String)
    }
    
    let emotesId: Set<String>
    let components: [Component]
    let sender: String
    let senderColor: ColorComponents?
}

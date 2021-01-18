//
//  ChatSocketService.swift
//  TwitchChat
//
//  Created by Aleksey Ostapenko on 03.01.2021.
//

import Foundation
import Combine

final class ChatSocketService {
    
    let socket: Socket
    init() {
        socket = Socket(url: URL(string: "wss://irc-ws.chat.twitch.tv")!)
        socket.resume()
        let cap = URLSessionWebSocketTask.Message.string("CAP REQ :twitch.tv/tags")
        socket.send(cap)
    }
    
    var publisher: AnyPublisher<SocketChatMessage, Never> {
        let messageParser = SocketMessageParser(tagParser: TagParserImpl(tagValueParser: TagValueParserImpl()))

        return socket
            .publisher
            .replaceError(with: .string(""))
            .compactMap {
                if case let .string(socketMessage) = $0, let message = messageParser.translate(socketMessage) {
                    return message
                } else {
                    return nil
                }
            }
            .eraseToAnyPublisher()
    }
    
    func connect(to channel: String, for user: User, with token: String) {
        let pass = URLSessionWebSocketTask.Message.string("PASS oauth:\(token)")
        socket.send(pass)
        let nick = URLSessionWebSocketTask.Message.string("NICK \(user.displayName.lowercased())")
        socket.send(nick)
        let user = URLSessionWebSocketTask.Message.string("USER (\(user.displayName.lowercased()) 8 * :\(user.displayName.lowercased())")
        socket.send(user)
        let join = URLSessionWebSocketTask.Message.string("JOIN #\(channel.lowercased())")
        socket.send(join)
    }
}

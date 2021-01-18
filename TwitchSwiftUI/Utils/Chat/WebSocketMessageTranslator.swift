//
//  WebSocketMessageTranslator.swift
//  Twitch
//
//  Created by Aleksey Ostapenko on 18.01.2021.
//

import SwiftUI
import Combine

final class WebSocketMessageTranslator {
    
    var bag = Set<AnyCancellable>()
    var bttvEmotes = [String: BTTVEmote]()
    let networkClient: NetworkClient
    let workQueue = DispatchQueue(label: "com.chatMessageTranslator.work")
    let emotesDataStorage = ImageCache<String>()
    
    init(channelID: String, networkClient: NetworkClient) {
        self.networkClient = networkClient
        let globalEmotes = networkClient.load(BTTVGlobalEmotesMethod())
        let channelEmotes = networkClient.load(BTTVChannelEmotesMethod(channelID: channelID))
        
        Publishers.Zip(channelEmotes, globalEmotes)
            .receive(on: workQueue)
            .sink(receiveCompletion: { _ in }) { [weak self] (channelEmotes, globalEmotes) in
                guard let self = self else { return }
                
                var emotes = [String: BTTVEmote]()
                channelEmotes.shared.forEach { emotes[$0.code] = $0 }
                channelEmotes.channel.forEach { emotes[$0.code] = $0 }
                globalEmotes.filter { emotes[$0.code] == nil }.forEach { emotes[$0.code] = $0 }
                self.bttvEmotes = emotes
            }
            .store(in: &bag)
    }
    
    private func transform(socketChatMessage message: SocketChatMessage) -> ChatMessage {
        let senderColor = message.senderColor.flatMap { Color($0) }
        let sender: [ChatMessage.Component] = [.sender(message.sender, senderColor ?? Color.random), .text(":"), .text(" ")]
        let components = message.components.reduce(sender) { result, component -> [ChatMessage.Component] in
            let nextValue: [ChatMessage.Component]
            switch component {
            case .emote(let id):
                if let imageData = emotesDataStorage.data(for: id) {
                    nextValue = [.image(imageData)]
                } else {
                    nextValue = []
                }
            case .text(let text):
                if let bttvEmote = bttvEmotes[text], let bttvImageData = emotesDataStorage.data(for: bttvEmote.id) {
                    switch bttvEmote.imageType {
                    case .gif:
                        nextValue = [.gif(bttvImageData)]
                    case .png:
                        nextValue = [.image(bttvImageData)]
                    }
                } else {
                    nextValue = [.text(text)]
                }
            }
            return result + nextValue
        }
        
        return ChatMessage(components: components)
    }
    
    func translate(_ socketChatMessage: SocketChatMessage) -> AnyPublisher<ChatMessage, Never> {
        Future<ChatMessage, Never>() { promise in
            self.workQueue.async {
                var bttvEmotes = Set<String>()
                socketChatMessage.components.forEach {
                    if case let .text(text) = $0, let bttvEmote = self.bttvEmotes[text] {
                        bttvEmotes.insert(bttvEmote.id)
                    }
                }
                
                var downloadsEmote = socketChatMessage
                    .emotesId
                    .filter { self.emotesDataStorage.data(for: $0) == nil }
                    .map { ($0, EmoteMethod(id: $0).request) }
                
                downloadsEmote.append(contentsOf:
                                        bttvEmotes
                                        .filter { self.emotesDataStorage.data(for: $0) == nil }
                                        .map { ($0, BTTVEmoteMethod(emoteID: $0, size: .small).request) }
                )
                
                let dispatchGroup = DispatchGroup()
                
                downloadsEmote.forEach { apiCall in
                    dispatchGroup.enter()
                    URLSession.shared.dataTask(with: apiCall.1) { data, response, error in
                        if let data = data, error == nil {
                            self.emotesDataStorage.save(data, for: apiCall.0)
                        }
                        dispatchGroup.leave()
                    }
                    .resume()
                }
                
                _ = dispatchGroup.wait(timeout: .now() + 2)
                promise(.success(self.transform(socketChatMessage: socketChatMessage)))
            }
        }
        .eraseToAnyPublisher()
    }
}

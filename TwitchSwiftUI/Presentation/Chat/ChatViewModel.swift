//
//  ChatViewModel.swift
//  TwitchChat
//
//  Created by Aleksey Ostapenko on 04.01.2021.
//

import Foundation
import Combine

class ChatViewModel: ObservableObject {
    @Published var messages = [ChatMessage]()
    private var disposeBag = Set<AnyCancellable>()
    private let chatService = ChatSocketService()
    private let messagesLimit = Int.max
    
    func load(networkClient: NetworkClient, for channel: String) {
        let translator = WebSocketMessageTranslator(channelID: channel, networkClient: networkClient)
        chatService
            .publisher
            .flatMap { translator.translate($0) }
            .receive(on: DispatchQueue.main)
            .compactMap { [weak self] message in
                guard let self = self else { return nil }
                
                if self.messages.count >= self.messagesLimit {
                    return self.messages.dropFirst(self.messages.count - self.messagesLimit) + [message]
                }
                
                return self.messages + [message] 
            }
            .assign(to: \.messages, on: self)
            .store(in: &disposeBag)
    }
    
    func lastMessagePublisher(onReceiveMessage: @escaping (ChatMessage) -> ()) {
        $messages.delay(for: .seconds(0.15), scheduler: DispatchQueue.main)
            .compactMap { $0.last }
            .sink(receiveValue: onReceiveMessage)
            .store(in: &disposeBag)
    }
    
    func connect(to channel: String, for user: User, with token: String) {
        chatService.connect(to: channel, for: user, with: token)
    }
    
    func clear() {
        disposeBag.removeAll()
        messages.removeAll()
    }
}

//
//  SocketSubscription.swift
//  Twitch
//
//  Created by Aleksey Ostapenko on 18.01.2021.
//

import Foundation
import Combine

final class SocketSubscription<S: Subscriber>: Subscription where S.Input == URLSessionWebSocketTask.Message, S.Failure == Error {
    var subscriber: S?
    var socket: URLSessionWebSocketTask?
    
    init(subscriber: S?, socket: URLSessionWebSocketTask?) {
        self.subscriber = subscriber
        self.socket = socket
    }
    
    func cancel() {
        subscriber = nil
        socket = nil
    }
    
    func request(_ demand: Subscribers.Demand) {
        guard demand > .none else {
            subscriber?.receive(completion: .finished)
            return
        }
        let count = demand - 1
        
        socket?.receive { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .failure(error):
                self.subscriber?.receive(completion: .failure(error))
            case let .success(message):
                _ = self.subscriber?.receive(message)
                self.request(count)
            }
        }
    }
}

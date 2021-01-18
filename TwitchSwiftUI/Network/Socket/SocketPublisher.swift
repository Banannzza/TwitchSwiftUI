//
//  SocketPublisher.swift
//  Twitch
//
//  Created by Aleksey Ostapenko on 18.01.2021.
//

import Foundation
import Combine

struct SocketPublisher: Publisher {
    typealias Output = URLSessionWebSocketTask.Message
    typealias Failure = Error
    
    var socket: URLSessionWebSocketTask
    
    func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        let subscription = SocketSubscription(subscriber: subscriber, socket: socket)
        subscriber.receive(subscription: subscription)
    }
}

extension URLSessionWebSocketTask {
    var publisher: SocketPublisher {
        SocketPublisher(socket: self)
    }
}

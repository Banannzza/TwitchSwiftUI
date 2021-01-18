//
//  Socket.swift
//  TwitchChat (iOS)
//
//  Created by Aleksey Ostapenko on 01.01.2021.
//

import Foundation
import Combine

final class Socket {
    var stopped: Bool
    let webSocket: URLSessionWebSocketTask
    let pingInterval = 60
    
    var publisher: SocketPublisher {
        webSocket.publisher
    }
    
    init(_ session: URLSession = URLSession.shared, url: URL) {
        webSocket = session.webSocketTask(with: url)
        stopped = true
    }
    
    deinit {
        webSocket.cancel(with: .goingAway, reason: nil)
        stopped = false
    }
    
    func resume() {
        stopped = false
        webSocket.resume()
        ping()
    }
    
    private func ping() {
        webSocket.sendPing { [weak self] error in
            guard let self = self, !self.stopped else { return }
            if let error = error {
                print("Error when sending PING \(error)")
            } else {
                print("Web Socket connection is alive")
                DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(self.pingInterval)) { [weak self] in
                    self?.ping()
                }
            }
        }
    }
    
    func send(_ message: URLSessionWebSocketTask.Message) {
        webSocket.send(message) { error in
            guard let error = error else { return }
            print("error", error)
        }
    }
}

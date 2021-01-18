//
//  NetworkClientEnvironmentKey.swift
//  Twitch
//
//  Created by Aleksey Ostapenko on 16.01.2021.
//

import SwiftUI

fileprivate struct NetworkClientEnvironmentKey: EnvironmentKey {
    static var defaultValue: NetworkClient = NetworkClient(token: "", clientID: "")
}

extension EnvironmentValues {
    var networkClient: NetworkClient {
        get { self[NetworkClientEnvironmentKey.self] }
        set { self[NetworkClientEnvironmentKey.self] = newValue }
    }
}

extension View {
    func networkClient(_ networkClient: NetworkClient) -> some View {
        self.environment(\.networkClient, networkClient)
    }
}


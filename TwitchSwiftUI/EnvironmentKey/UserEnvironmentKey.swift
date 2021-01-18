//
//  UserEnvironmentKey.swift
//  Twitch
//
//  Created by Aleksey Ostapenko on 14.01.2021.
//

import SwiftUI

fileprivate struct UserEnvironmentKey: EnvironmentKey {
    static var defaultValue: User = User(id: "", displayName: "", type: .ordinary, profileURL: nil)
}

extension EnvironmentValues {
    var user: User {
        get { self[UserEnvironmentKey.self] }
        set { self[UserEnvironmentKey.self] = newValue }
    }
}

extension View {
    func authorizedUser(_ user: User) -> some View {
        self.environment(\.user, user)
    }
}

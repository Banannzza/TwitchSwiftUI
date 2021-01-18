//
//  TwitchSwiftUIApp.swift
//  TwitchSwiftUI
//
//  Created by Aleksey Ostapenko on 18.01.2021.
//

import SwiftUI

final class AppState: ObservableObject {
    @Published var selectedStream: StreamInfo?
    @Published var user: User?
}

@main
struct TwitchApp: App {
    @AppStorage(.token) var token: String?
    @StateObject var appState = AppState()
    
    @ViewBuilder var content: some View {
        if let user = appState.user {
            NavigationView {
                UserFollows()
                    .authorizedUser(user)
                    .navigationTitle("Follows")
            }
            .navigationViewStyle(StackNavigationViewStyle())
        } else {
            UserLoader($appState.user)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            if let token = token {
                content
                    .networkClient(NetworkClient(token: token, clientID: AppConfiguration.clientID))
                    .environmentObject(appState)
            } else {
                Authorization(redirectHost: AppConfiguration.authorizationRedirectHost)
                    .transition(AnyTransition.slide.animation(.linear))
            }
        }
    }
}

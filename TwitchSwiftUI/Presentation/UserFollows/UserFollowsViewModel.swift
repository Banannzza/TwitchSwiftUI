//
//  UserFollows.swift
//  Twitch
//
//  Created by Aleksey Ostapenko on 14.01.2021.
//

import SwiftUI
import Combine

final class UserFollowsViewModel: ObservableObject {
    private var disposeBag = Set<AnyCancellable>()
    @Published var viewData: UserFollowsViewData? = nil
    
    func load(network: NetworkClient, for user: User) {
        network.load(FollowsMethod(from: user.id))
            .map { $0.data }
            .flatMap { input -> AnyPublisher<([User], [StreamInfo]), Never> in
                let usersID = input.map { $0.toId }
                let users = network.load(UserMethod(ids: usersID)).map { $0.data }.replaceError(with: [])
                let onlineStreams = network.load(StreamsMethod(userIds: usersID)).map { $0.data }.replaceError(with: [])
                return Publishers.Zip(users, onlineStreams).eraseToAnyPublisher()
             }
            .replaceError(with: ([], []))
            .map { UserFollowsViewDataBuilder().transform(onlineStreams: $0.1, users: $0.0)}
            .receive(on: DispatchQueue.main)
            .assign(to: \.viewData, on: self)
            .store(in: &disposeBag)
    }
}

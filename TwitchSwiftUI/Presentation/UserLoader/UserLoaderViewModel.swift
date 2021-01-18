//
//  UserLoading.swift
//  Twitch
//
//  Created by Aleksey Ostapenko on 14.01.2021.
//

import SwiftUI
import Combine

final class UserLoaderViewModel: ObservableObject {
    @AppStorage(.token) var token: String?
    @Binding var user: User?
    private var disposeBag = Set<AnyCancellable>()
    
    init(_ user: Binding<User?>) {
        self._user = user
    }
    
    func load(network: NetworkClient) {
        network.load(UserMethod())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case let .failure(reason) = completion {
                    switch reason {
                    case .authorization:
                        self?.token = nil
                    default:
                        break
                    }
                }
            } receiveValue: { [weak self] response in
                self?.user = response.data.first
            }
            .store(in: &disposeBag)
    }
}

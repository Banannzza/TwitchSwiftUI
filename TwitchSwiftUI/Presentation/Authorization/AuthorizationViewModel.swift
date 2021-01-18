//
//  AuthorizationViewModel.swift
//  Twitch
//
//  Created by Aleksey Ostapenko on 14.01.2021.
//

import SwiftUI
import Combine

final class AuthorizationViewModel: ObservableObject {
    @AppStorage(.token) var token: String?
    var disposeBag = Set<AnyCancellable>()
    
    var codeRequest: URLRequest {
        AuthorizationMethod(
            clientID: AppConfiguration.clientID,
            redirectURI: AppConfiguration.authorizationRedirectUri,
            scope: .userEdit
        ).request
    }
    
    func process(codeRedirectURL url: URL) {
        guard let query = url.absoluteString.split(separator: "#").last else { return }
        
        token = query
            .split(separator: "&")
            .lazy
            .map { $0.split(separator: "=") }
            .first { $0.first == "access_token" }?
            .last
            .flatMap { String($0) }
    }
}

//
//  AuthorizationMethod.swift
//  TwitchApi
//
//  Created by adostapenko on 11.01.2021.
//

import Foundation

struct AuthorizationMethod: ApiMethod {
    
    enum Scope: String {
        case userEdit = "user:edit"
    }
    
    let response = Any.self
    let host: String = "https://id.twitch.tv/oauth2/authorize"
    let authorized = false
    let method: HTTPMethod = .get
    let params: [String : String]
    
    init(
        clientID: String,
        redirectURI: String,
        scope: Scope...)
    {
        params = [
            "client_id": clientID,
            "redirect_uri": redirectURI,
            "response_type": "token",
            "scope": scope.lazy.map{ $0.rawValue }.joined()
        ]
    }
}

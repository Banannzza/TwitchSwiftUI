//
//  UserMethod.swift
//  Twitch
//
//  Created by Aleksey Ostapenko on 14.01.2021.
//

import Foundation

struct UserMethod: ApiMethod {
    let response = BackendArray<User>.self
    let authorized: Bool = true
    let method: HTTPMethod = .get
    let params: [String : String] = [:]
    let host = "https://api.twitch.tv/helix/users"
    let logins: [String]
    let ids: [String]
    
    init(logins: [String] = [], ids: [String] = []) {
        self.logins = logins
        self.ids = ids
    }
    
    var queryParams: String {
        let loginsQuery = logins.map { "login=\($0)" }
        let idsQuery = ids.map { "id=\($0)" }
        return (loginsQuery + idsQuery).joined(separator: "&")
    }
}

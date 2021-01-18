//
//  APIMethod.swift
//  TwitchApi
//
//  Created by adostapenko on 11.01.2021.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol ApiMethod {
    associatedtype Response
    
    var response: Response.Type { get }
    var authorized: Bool { get }
    var method: HTTPMethod { get }
    var request: URLRequest { get }
    var url: URL { get }
    var params: [String: String] { get }
    var host: String { get }
    var queryParams: String { get }
}

extension ApiMethod {
    var queryParams: String {
        return params.lazy.map({ "\($0.key)=\($0.value)" }).joined(separator: "&")
    }
    
    var url: URL {
        guard method == .get else { return URL(string: host)! }
        let parameters = queryParams
        let uri = host + (parameters.isEmpty ? "" : "?\(parameters)")
        return URL(string: uri)!
    }
    
    var request: URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        if method == .post {
            urlRequest.httpBody = queryParams.data(using: .utf8)
        }
        
        return urlRequest
    }
}

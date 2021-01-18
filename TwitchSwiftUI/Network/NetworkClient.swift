//
//  NetworkClient.swift
//  TwitchApi
//
//  Created by adostapenko on 11.01.2021.
//

import Foundation
import SwiftUI
import Combine

final class NetworkClient: ObservableObject {
    enum Header: String {
        case authorization = "Authorization"
        case client = "Client-ID"
    }
    
    enum Failure: Error {
        case authorization
        case unknown
        case other(Error)
    }
    
    private let token: String
    private let clientID: String
    
    init(
        token: String,
        clientID: String)
    {
        self.token = "Bearer \(token)"
        self.clientID = clientID
    }
    
    func load<API: ApiMethod, Data: Decodable>(_ method: API) -> AnyPublisher<Data, Failure> where API.Response == Data {
        self.load(method, response: Data.self)
    }
    
    func load<API: ApiMethod, Data: Decodable>(_ method: API, response: Data.Type) -> AnyPublisher<Data, Failure> {
        method.authorized ? send(authorized(method.request)) : send(method.request)
    }
    
    func load<API: ApiMethod>(_ method: API) -> AnyPublisher<Data, Failure> where API.Response == Data {
        URLSession
            .shared
            .dataTaskPublisher(for: method.authorized ? authorized(method.request) : method.request)
            .map { $0.data }
            .mapError { Failure.other($0)}
            .eraseToAnyPublisher()
    }
    
    private func authorized(_ request: URLRequest) -> URLRequest {
        guard token.isNotEmpty && clientID.isNotEmpty else { fatalError("Network client not initialized") }
        
        var authoriziedRequest = request
        authoriziedRequest.addValue(token, forHTTPHeaderField: .authorization)
        authoriziedRequest.addValue(clientID, forHTTPHeaderField: .client)
        return authoriziedRequest
    }
    
    private func send<Data: Decodable>(_ request: URLRequest) -> AnyPublisher<Data, Failure>  {
        URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { data, response in
                let decoder = JSONDecoder()
                if let object = try? decoder.decode(Data.self, from: data) {
                    return object
                }
                let error = try decoder.decode(BackendError.self, from: data)
                
                switch error.status {
                case 401:
                    throw Failure.authorization
                default:
                    throw Failure.unknown
                }
            }
            .mapError {
                if $0 is Failure {
                    return $0 as! Failure
                } else {
                    return Failure.other($0)
                }
            }
            .eraseToAnyPublisher()
    }
}

fileprivate extension URLRequest {
    mutating func addValue(_ value: String, forHTTPHeaderField header: NetworkClient.Header) {
        addValue(value, forHTTPHeaderField: header.rawValue)
    }
}

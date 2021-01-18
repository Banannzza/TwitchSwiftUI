//
//  UserType.swift
//  Twitch
//
//  Created by Aleksey Ostapenko on 14.01.2021.
//

import Foundation

enum UserType: Decodable {
    
    enum DecodeError: Error {
        case unknownType
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        switch CodingKeys(stringValue: value) {
        case .staff:
            self = .staff
        case .admin:
            self = .admin
        case .globalModarator:
            self = .globalModarator
        case .ordinary:
            self = .ordinary
        case nil:
            throw DecodeError.unknownType
        }
    }
    
    case staff
    case admin
    case globalModarator
    case ordinary
    
    enum CodingKeys: String, CodingKey {
        case staff
        case admin
        case globalModarator = "global_mod"
        case ordinary = ""
    }
}

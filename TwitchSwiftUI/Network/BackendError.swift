//
//  BackendError.swift
//  Twitch
//
//  Created by Aleksey Ostapenko on 14.01.2021.
//

import Foundation

struct BackendError: Decodable {
    let message: String
    let status: Int
}

//
//  BackendArray.swift
//  Twitch
//
//  Created by Aleksey Ostapenko on 14.01.2021.
//

import Foundation

struct BackendArray<Element: Decodable>: Decodable {
    let data: [Element]
}

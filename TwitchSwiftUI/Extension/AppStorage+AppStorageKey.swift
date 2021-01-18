//
//  AppStorage+AppStorageKey.swift
//  Twitch
//
//  Created by Aleksey Ostapenko on 14.01.2021.
//

import SwiftUI

extension AppStorage where Value: ExpressibleByNilLiteral {
    init(_ key: AppStorageKey) where Value == String? {
        self.init(key.rawValue)
    }
}

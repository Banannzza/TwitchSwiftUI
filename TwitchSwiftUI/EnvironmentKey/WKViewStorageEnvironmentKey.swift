//
//  WKViewStorageEnvironmentKey.swift
//  Twitch
//
//  Created by Aleksey Ostapenko on 17.01.2021.
//

import SwiftUI

struct WKViewStorageEnvironmentKey: EnvironmentKey {
    static var defaultValue = WKViewStorage()
}

extension EnvironmentValues {
    var wkViewStorage: WKViewStorage {
        get { self[WKViewStorageEnvironmentKey.self] }
        set { self[WKViewStorageEnvironmentKey.self] = newValue }
    }
}

//
//  ImageCacheEnvironmentKey.swift
//  Twitch
//
//  Created by Aleksey Ostapenko on 15.01.2021.
//

import SwiftUI

fileprivate struct ImageCacheEnvironmentKey: EnvironmentKey {
    static var defaultValue = ImageCache<URL>()
}

extension EnvironmentValues {
    var imageCache: ImageCache<URL> {
        get { self[ImageCacheEnvironmentKey.self] }
        set { self[ImageCacheEnvironmentKey.self] = newValue }
    }
}

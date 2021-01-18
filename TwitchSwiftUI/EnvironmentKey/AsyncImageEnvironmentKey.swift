//
//  AsyncImageEnvironmentKey.swift
//  Twitch
//
//  Created by Aleksey Ostapenko on 15.01.2021.
//

import SwiftUI

fileprivate struct AsyncImageDownloadedImageTransition: EnvironmentKey {
    static var defaultValue = AnyTransition.opacity.animation(.linear(duration: 0.3))
}

fileprivate struct AsyncImageCachedImageTransition: EnvironmentKey {
    static var defaultValue = AnyTransition.identity
}

extension EnvironmentValues {
    var downloadedImageTransition: AnyTransition {
        get { self[AsyncImageDownloadedImageTransition.self] }
        set { self[AsyncImageDownloadedImageTransition.self] = newValue }
    }
    
    var cachedImageTransition: AnyTransition {
        get { self[AsyncImageCachedImageTransition.self] }
        set { self[AsyncImageCachedImageTransition.self] = newValue }
    }
}

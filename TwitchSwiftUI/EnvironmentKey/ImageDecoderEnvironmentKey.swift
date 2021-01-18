//
//  ImageDecoderEnvironmentKey.swift
//  Twitch
//
//  Created by Aleksey Ostapenko on 15.01.2021.
//

import SwiftUI

fileprivate struct ImageDecoderEnvironmentKey: EnvironmentKey {
    static var defaultValue = ImageDecoder()
}

extension EnvironmentValues {
    var imageDecoder: ImageDecoder {
        get { self[ImageDecoderEnvironmentKey.self] }
        set { self[ImageDecoderEnvironmentKey.self] = newValue }
    }
}

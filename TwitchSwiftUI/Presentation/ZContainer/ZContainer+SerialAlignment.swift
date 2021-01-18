//
//  ZContainer + ZContainerSerialAlignment.swift
//  Scorpio
//
//  Created by Aleksey Ostapenko on 10.01.2021.
//

import SwiftUI

extension ZContainer where Layout == ZContainerSerialAlignment {
    init(
        maxWidth: CGFloat,
        _ data: Data,
        @ViewBuilder content: @escaping Self.ContentBlock)
    {
        self.init(maxWidth: maxWidth, alignment: .topLeading, data: data, content: content) { ZContainerSerialAlignment(index: $0, layoutStorage: $1) }
    }
}



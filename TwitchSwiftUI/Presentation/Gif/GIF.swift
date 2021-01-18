//
//  GIF.swift
//  Twitch
//
//  Created by Aleksey Ostapenko on 17.01.2021.
//

import SwiftUI
import SwiftyGif

struct GIF: UIViewRepresentable {
    func updateUIView(_ uiView: UIViewType, context: Context) {}
    
    let image: UIImage
    
    init(_ image: UIImage) {
        self.image = image
    }
    
    init(_ data: Data) {
        image = (try? UIImage(gifData: data)) ?? UIImage()
    }
    
    func makeUIView(context: Context) -> some UIView {
        UIImageView(gifImage: image)
    }
    
}

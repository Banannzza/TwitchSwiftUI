//
//  Color.swift
//  Scorpio
//
//  Created by Aleksey Ostapenko on 10.01.2021.
//

import SwiftUI

typealias ColorComponents = (r: Double, g: Double, b: Double, a: Double)

extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
    
    init(_ components: ColorComponents) {
        self.init(red: components.r, green: components.g, blue: components.b)
    }
}

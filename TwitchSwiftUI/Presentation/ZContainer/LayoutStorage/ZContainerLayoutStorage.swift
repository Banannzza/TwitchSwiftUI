//
//  ZContainerLayoutStorage.swift
//  Scorpio
//
//  Created by Aleksey Ostapenko on 10.01.2021.
//

import SwiftUI

protocol ZContainerLayoutStorage: class {
    var itemsLayout: [ZContainerLayout] { get set }
    var isWidthEnough: Bool { get set }
    var maxWidth: CGFloat { get }
    
    func layout(for index: Int) -> ZContainerLayout?
    func isLayouted(at index: Int) -> Bool
    func isNotLayouted(at index: Int) -> Bool
    func leadingAlignment(at index: Int) -> CGFloat
    func update(maxWidth: CGFloat)
    
    subscript(index: Int) -> ZContainerLayout { get }
}

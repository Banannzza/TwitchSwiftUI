//
//  ZContainerLayoutStorageImpl.swift
//  Scorpio
//
//  Created by Aleksey Ostapenko on 10.01.2021.
//

import SwiftUI

final class ZContainerLayoutStorageImpl: ZContainerLayoutStorage {
    private(set) var maxWidth: CGFloat
    var itemsLayout: [ZContainerLayout]
    var isWidthEnough: Bool
    
    init(maxWidth: CGFloat? = nil) {
        self.maxWidth = maxWidth ?? 0
        isWidthEnough = maxWidth != nil
        itemsLayout = []
    }
    
    func layout(for index: Int) -> ZContainerLayout? {
        itemsLayout.element(at: index)
    }
    
    func isLayouted(at index: Int) -> Bool {
        itemsLayout.element(at: index) != nil
    }
    
    func isNotLayouted(at index: Int) -> Bool {
        !isLayouted(at: index)
    }
    
    func leadingAlignment(at index: Int) -> CGFloat {
        layout(for: index)?.x ?? 0
    }
    
    func update(maxWidth: CGFloat) {
        guard maxWidth != self.maxWidth else { return }
        
        self.maxWidth = maxWidth
        if !isWidthEnough || (itemsLayout.last?.trailing ?? 0) > maxWidth {
            itemsLayout.removeAll()
        }
        isWidthEnough = true
    }
    
    subscript(index: Int) -> ZContainerLayout {
        itemsLayout[index]
    }
}

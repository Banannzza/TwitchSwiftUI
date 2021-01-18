//
//  ZContainerSerialAlignment.swift
//  Scorpio
//
//  Created by Aleksey Ostapenko on 10.01.2021.
//

import SwiftUI

struct ZContainerSerialAlignment: ViewModifier {
    let index: Int
    fileprivate let layoutStorage: ZContainerLayoutStorage
    
    init(index: Int, layoutStorage: ZContainerLayoutStorage) {
        self.index = index
        self.layoutStorage = layoutStorage
    }
    
    func body(content: Content) -> some View {
        content
            .alignmentGuide(.leading) { leadingAlignment($0) }
            .alignmentGuide(.top) { topAlignment($0) }
    }
    
    private func updateLineItemsTopAlignment(by height: CGFloat, baseTopAlignment top: CGFloat) {
        for index in layoutStorage.itemsLayout.indices.reversed() {
            layoutStorage.itemsLayout[index].y = top + (height - layoutStorage[index].height) / 2
            if layoutStorage.itemsLayout[index].x == 0 {
                break
            }
        }
    }
    
    private func maxLineBottomAlignment() -> CGFloat {
        var height: CGFloat = 0
        for layout in layoutStorage.itemsLayout.reversed() {
            height = max(height, layout.bottom)
            if layout.x == 0 {
                break
            }
        }
        return height
    }
    
    // MARK: - AlignmentGuide
    
    private func leadingAlignment(_ dimension: ViewDimensions) -> CGFloat {
        guard layoutStorage.isNotLayouted(at: index) else { return -layoutStorage.leadingAlignment(at: index) }
        
        let point: CGPoint
        if let prevItemLayout = layoutStorage.layout(for: index - 1) {
            if prevItemLayout.trailing + dimension.width > layoutStorage.maxWidth {
                point = CGPoint(x: 0, y: maxLineBottomAlignment())
                layoutStorage.isWidthEnough = false
            } else {
                let lineTopAlignment: CGFloat
                if prevItemLayout.height < dimension.height {
                    lineTopAlignment = prevItemLayout.y
                    updateLineItemsTopAlignment(by: dimension.height, baseTopAlignment: lineTopAlignment)
                } else {
                    lineTopAlignment = prevItemLayout.y + (prevItemLayout.height - dimension.height) / 2
                }
                point = CGPoint(x: prevItemLayout.trailing, y: lineTopAlignment)
            }
        } else {
            point = .zero
        }
        
        layoutStorage.itemsLayout.append(ZContainerLayout(point, dimension))
        return -point.x
    }
    
    private func topAlignment(_ dimension: ViewDimensions) -> CGFloat {
        -(layoutStorage.layout(for: index)?.y ?? 0)
    }
}

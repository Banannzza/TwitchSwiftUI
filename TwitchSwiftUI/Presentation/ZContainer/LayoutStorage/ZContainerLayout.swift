//
//  ZContainerLayout.swift
//  Scorpio
//
//  Created by Aleksey Ostapenko on 10.01.2021.
//

import SwiftUI

struct ZContainerLayout {
    private let size: CGSize
    private var point: CGPoint
    
    init(_ point: CGPoint, _ dimension: ViewDimensions) {
        self.point = point
        size = CGSize(width: dimension.width, height: dimension.height)
    }
    
    var trailing: CGFloat { point.x + width }
    var bottom: CGFloat { point.y + height }
    var width: CGFloat { size.width }
    var height: CGFloat { size.height }
    var x: CGFloat { point.x }
    var y: CGFloat {
        get { point.y }
        set { point = CGPoint(x: point.x, y: newValue) }
    }
}

//
//  ZContainer.swift
//  Scorpio
//
//  Created by Aleksey Ostapenko on 10.01.2021.
//

import SwiftUI

struct ZContainer<Data, Content, Layout>: View where Data: RandomAccessCollection, Content: View, Layout: ViewModifier, Data.Index == Int {
    
    typealias ContentBlock = (Data.Element) -> Content
    typealias LayoutBlock = (_ index: Int, _ layoutStorage: ZContainerLayoutStorage) -> Layout
    
    private let layoutStorage = ZContainerLayoutStorageImpl()
    
    private let alignment: Alignment
    private let data: Data
    private let content: ContentBlock
    private let layout: LayoutBlock
    private let maxWidth: CGFloat
    
    init(
        maxWidth: CGFloat,
        alignment: Alignment,
        data: Data,
        @ViewBuilder content: @escaping ContentBlock,
        layout: @escaping LayoutBlock)
    {
        self.maxWidth = maxWidth
        self.alignment = alignment
        self.data = data
        self.content = content
        self.layout = layout
    }
    
    private func modifiedContent(_ element: Data.Element, at index: Int) -> some View {
        return content(element)
            .modifier(layout(index, layoutStorage))
    }
    
    private func content(maxWidth: CGFloat) -> some View {
        layoutStorage.update(maxWidth: maxWidth)
        return ForEach(data.indices, id: \.self) {
            return modifiedContent(data[$0], at: $0)
        }
    }
    
    var body: some View {
        ZStack(alignment: alignment) {
            content(maxWidth: maxWidth)
        }
    }
}

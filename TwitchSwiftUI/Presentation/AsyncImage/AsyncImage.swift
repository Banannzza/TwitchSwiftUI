//
//  StreamPreview.swift
//  TwitchApi
//
//  Created by adostapenko on 12.01.2021.
//

import SwiftUI
import Combine

struct AsyncImage<Placeholder>: View where Placeholder: View {
    @Environment(\.imageCache) var imageCache
    @Environment(\.imageDecoder) var imageDecoder
    @Environment(\.downloadedImageTransition) var downloadedImageTransition
    @Environment(\.cachedImageTransition) var cachedImageTransition
    @StateObject private var viewModel: AsyncImageViewModel
    private let placeholder: Placeholder
    
    init(_ url: URL, @ViewBuilder placeholder: () -> Placeholder) {
        self.placeholder = placeholder()
        _viewModel = StateObject(wrappedValue: AsyncImageViewModel(url))
    }
    
    @ViewBuilder var content: some View {
        if let cachedImage = viewModel.cachedImage {
            Image(uiImage: cachedImage)
                .resizable()
                .transition(cachedImageTransition)
        }
        if let downloadedImage = viewModel.downloadedImage {
            Image(uiImage: downloadedImage)
                .resizable()
                .transition(downloadedImageTransition)
        }
        if viewModel.downloadedImage == nil && viewModel.cachedImage == nil {
            placeholder
        }
    }
    
    var body: some View {
        GeometryReader { proxy in
            content.onAppear {
                viewModel.load(
                    decoder: imageDecoder,
                    to: proxy.size,
                    saveIn: imageCache,
                    with: .forever
                )
            }
        }
    }
}

extension AsyncImage where Placeholder == Color {
    init(_ url: URL) {
        self.init(url, placeholder: { Color.clear })
    }
}

extension AsyncImage {
    func imageTransition(downloaded: AnyTransition = .identity, cached: AnyTransition = .identity) -> some View  {
        self
            .environment(\.downloadedImageTransition, downloaded)
            .environment(\.cachedImageTransition, cached)
    }
}

//
//  AsyncImageViewModel.swift
//  Twitch
//
//  Created by Aleksey Ostapenko on 15.01.2021.
//

import SwiftUI
import Combine

final class AsyncImageViewModel: ObservableObject {
    
    typealias Cache = ImageCache<URL>
    
    @Published var downloadedImage: UIImage?
    @Published var cachedImage: UIImage?
    private var bag = Set<AnyCancellable>()
    private let url: URL
    
    init(_ url: URL) {
        self.url = url
    }
    
    func load(
        decoder: ImageDecoder,
        to size: CGSize,
        saveIn cache: Cache,
        with policy: Cache.Policy)
    {
        let imageURL = url
        if let cachedData = cache.data(for: imageURL) {
            decoder.decode(cachedData, to: size)
                .receive(on: DispatchQueue.main)
                .assign(to: \.cachedImage, on: self)
                .store(in: &bag)
        } else {
            URLSession
                .shared
                .dataTaskPublisher(for: imageURL)
                .map { response -> Data in
                    cache.save(response.data, for: imageURL, with: policy)
                    return response.data
                }
                .map { decoder.decode($0, to: size) }
                .replaceError(with: nil)
                .receive(on: DispatchQueue.main)
                .assign(to: \.downloadedImage, on: self)
                .store(in: &bag)
        }
    }
    
}

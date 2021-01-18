//
//  ImageDecoder.swift
//  Twitch
//
//  Created by Aleksey Ostapenko on 15.01.2021.
//

import UIKit
import Combine

final class ImageDecoder {
    
    private let workQueue = DispatchQueue(label: "com.imageDecoder", attributes: .concurrent)
    
    func decode(_ data: Data, to size: CGSize? = nil, scale: CGFloat = UIScreen.main.scale) -> UIImage? {
        guard let size = size else { return UIImage(data: data, scale: scale) }
        
        return downsample(data, to: size, scale: scale)
    }
    
    func decode(_ data: Data, to size: CGSize? = nil, scale: CGFloat = UIScreen.main.scale) -> AnyPublisher<UIImage?, Never> {
        Future { [weak self] promise in
            self?.workQueue.async {
                guard let size = size else {
                    promise(.success(UIImage(data: data, scale: scale)))
                    return
                }
                    
                promise(.success(self?.downsample(data, to: size, scale: scale)))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func downsample(
        _ data: Data,
        to size: CGSize,
        scale: CGFloat) -> UIImage?
    {
        let options = [kCGImageSourceShouldCache: false] as CFDictionary
        
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, options) else {
            return nil
        }
        
        let maxDimensionInPixels = max(size.width, size.height) * scale
        
        let downsampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
        ] as CFDictionary
        
        guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
            return nil
        }
        
        return UIImage(cgImage: downsampledImage)
    }
}

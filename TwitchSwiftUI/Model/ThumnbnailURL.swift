//
//  ThumnbnailURL.swift
//  TwitchApi
//
//  Created by adostapenko on 11.01.2021.
//

import Foundation

struct ThumnbnailURL: Decodable, Equatable {
    
    private let source: String
    private let fileFormat: String
    
    init?(_ format: String) {
        let reversedFormat = format.reversed()
        let pattern = "{width}x{height}".reversed()
        var patternIndex = pattern.startIndex
        var formatIndex = reversedFormat.startIndex
        var fileFormatEndIndex: ReversedCollection<String>.Index? = nil
        
        while patternIndex < pattern.endIndex && formatIndex < reversedFormat.endIndex {
            if reversedFormat[formatIndex] == pattern[patternIndex] {
                patternIndex = pattern.index(after: patternIndex)
            } else if patternIndex != pattern.startIndex {
                break
            }
            
            if fileFormatEndIndex == nil && reversedFormat[formatIndex] == "." {
                fileFormatEndIndex = formatIndex
            }
            
            formatIndex = reversedFormat.index(after: formatIndex)
        }
        
        guard
            patternIndex == pattern.endIndex,
            let formatEndIndex = fileFormatEndIndex
        else { return nil }
        
        
        fileFormat = String(reversedFormat[reversedFormat.startIndex...formatEndIndex].reversed())
        source = String(reversedFormat[formatIndex...].reversed())
    }
    
    func url(width: Int, height: Int) -> URL {
        URL(string: source + "\(width)x\(height)" + fileFormat)!
    }
}

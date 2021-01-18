//
//  TagParserImpl.swift
//  TwitchChat
//
//  Created by Aleksey Ostapenko on 02.01.2021.
//

import Foundation

struct TagParserImpl: TagParser {
    let tagValueParser: TagValueParser
    
    init(tagValueParser: TagValueParser) {
        self.tagValueParser = tagValueParser
    }
    
    func tags(from string: String.SubSequence, startIndex: String.Index, endIndex: inout String.Index) -> [SocketMessageTag: SocketMessageTag.Value] {
        var tags = [SocketMessageTag: SocketMessageTag.Value]()
        var index = startIndex
        var word = ""
        
        while index < string.endIndex {
            let currentCharacter = string[index]
            index = string.index(after: index)
            
            guard currentCharacter != " " else { break }
            
            if currentCharacter == "=" {
                if let tag = SocketMessageTag(rawValue: word) {
                    tagValueParser.value(for: tag, from: string[index...], endIndex: &index).flatMap { tags[tag] = $0 }
                } else {
                    guard string[index] != " " else { continue }
                    string[index...].firstIndex(of: ";").flatMap { index = string.index(after: $0) }
                }
                word.removeAll()
            } else {
                word.append(currentCharacter)
            }
        }
        endIndex = index
        return tags
    }
}

//
//  SocketMessageParser.swift
//  TwitchChat
//
//  Created by Aleksey Ostapenko on 02.01.2021.
//

import Foundation

struct SocketMessageParser {
    
    let tagParser: TagParser
    
    init(tagParser: TagParser) {
        self.tagParser = tagParser
    }
    
    enum Command: String {
        case privmsg = "PRIVMSG"
    }
    
    private func removeNewLine<S: StringProtocol>(_ text: S) -> String {
        guard let lastCharacter = text.last, lastCharacter.isNewline else { return String(text) }
        return String(text.dropLast())
    }

    private func transformCommandMessage(_ string: String.SubSequence, emotes: Emotes, color: ColorComponents?, displayName: String?) -> SocketChatMessage? {
        var intIndex = 0
        var emoteRangeIndex = 0
        var index = string.startIndex
        var components = [SocketChatMessage.Component]()
        var emotesId = Set<String>()
        var wordStartIndex: String.Index?
        
        while index < string.endIndex {
            if let startIndex = wordStartIndex, string[index] == " " {
                components.append(.text(String(string[startIndex..<index])))
                components.append(.text(" "))
                wordStartIndex = nil
            } else if emotes.isNotEmpty, intIndex == emotes.ranges[emoteRangeIndex].lowerBound {
                if let wordStartIndex = wordStartIndex {
                    components.append(.text(String(string[wordStartIndex..<index])))
                }
                
                intIndex = emotes.ranges[emoteRangeIndex].upperBound
                index = string.index(index, offsetBy: emotes.ranges[emoteRangeIndex].count - 1)
                emotes.emotes[emoteRangeIndex].flatMap {
                    components.append(.emote(id: String($0)))
                    emotesId.insert(String($0))
                }
                emoteRangeIndex = min(emoteRangeIndex + 1, emotes.ranges.count - 1)
                wordStartIndex = nil
            } else {
                if wordStartIndex == nil {
                    wordStartIndex = index
                }
            }
            
            index = string.index(after: index)
            intIndex += 1
        }
        
        if let wordStartIndex = wordStartIndex {
            components.append(.text(String(string[wordStartIndex..<index])))
        }
        
        
        if case let .text(lastText) = components.last {
            components[components.count - 1] = .text(removeNewLine(lastText))
        }
        
        
        return SocketChatMessage(
            emotesId: emotesId,
            components: components,
            sender: displayName ?? "",
            senderColor: color
        )
    }
    
    func translate(_ socketMessage: String) -> SocketChatMessage? {
        guard socketMessage.first == "@" else { return nil }
        
        var index = socketMessage.index(after: socketMessage.startIndex)
        
        let tags = tagParser.tags(from: socketMessage[index...], startIndex: index, endIndex: &index)
        
        var wordBeginIndex: String.Index?

        while index < socketMessage.endIndex {
            if socketMessage[index] == " " {
                defer { wordBeginIndex = nil }
                guard let wordBeginIndex = wordBeginIndex else { continue }
                let word = socketMessage[wordBeginIndex..<index]
                
                switch word {
                case Command.privmsg.rawValue:
                    guard
                        let colonIndex = socketMessage[index...].firstIndex(of: ":")
                        else { return nil }
                    
                    return transformCommandMessage(
                        socketMessage[socketMessage.index(after: colonIndex)...],
                        emotes: tags.emotes,
                        color: tags.color,
                        displayName: tags.displayName
                    )
                default:
                    break
                }
            } else {
                if wordBeginIndex == nil {
                    wordBeginIndex = index
                }
            }
            
            index = socketMessage.index(after: index)
        }
        return nil
    }
}

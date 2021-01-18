//
//  TagValueParserImpl.swift
//  TwitchChat
//
//  Created by Aleksey Ostapenko on 02.01.2021.
//

import Foundation

struct TagValueParserImpl: TagValueParser {
    
    private func colorComponents(from hexString: String) -> ColorComponents? {
        var convertedHexString: String
        if hexString.first == "#" {
            convertedHexString = String(hexString.dropFirst())
        } else {
            convertedHexString = String(hexString)
        }
        
        var hexNumber: UInt64 = 0
        let hexLength = convertedHexString.count
        if hexLength == 8 || hexLength == 6 {
            Scanner(string: convertedHexString).scanHexInt64(&hexNumber)
            
            let r, g, b, a: Double
            if hexLength == 8 {
                a = Double((hexNumber & 0xff000000 ) >> 24) / 255
                r = Double((hexNumber & 0x00ff0000) >> 16) / 255
                g = Double((hexNumber & 0x0000ff00) >> 8) / 255
                b = Double(hexNumber & 0x000000ff) / 255
            } else {
                a = 1
                r = Double((hexNumber & 0xff0000) >> 16) / 255
                g = Double((hexNumber & 0x00ff00) >> 8) / 255
                b = Double(hexNumber & 0x0000ff) / 255
            }
            return (r, g, b, a)
        } else {
            return nil
        }
    }
    
    private func string(from string: String.SubSequence, endIndex: inout String.Index) -> SocketMessageTag.Value? {
        var index = string.startIndex
        var value = ""
        
        while index < string.endIndex {
            let currentCharacter = string[index]
            
            guard currentCharacter != ";" else { break }
            
            index = string.index(after: index)
            value.append(currentCharacter)
        }
        
        if index < string.endIndex {
            endIndex = string.index(after: index)
        }
        
        if index == string.startIndex {
            return nil
        } else {
            return .string(value)
        }
    }
    
    private func emotePositionRanges(from string: String.SubSequence, endIndex: inout String.Index) -> [ClosedRange<Int>] {
        var index = string.startIndex
        var emoteIndicies = [Int]()
        var emoteRanges = [ClosedRange<Int>]()
        var number = ""
        
        outerWhile: while index < string.endIndex {
            let currentCharacter = string[index]
            index = string.index(after: index)
            
            switch currentCharacter {
            case "-", ",":
                Int(number).flatMap { emoteIndicies.append($0) }
                number.removeAll()
            case ";", "/":
                Int(number).flatMap { emoteIndicies.append($0) }
                guard emoteIndicies.count % 2 == 0 else {
                    break outerWhile
                }
                let indices = (0..<(emoteIndicies.count / 2))
                emoteRanges = indices.map { emoteIndicies[($0 * 2)]...emoteIndicies[($0 * 2) + 1] }
                break outerWhile
            default:
                number.append(currentCharacter)
            }
        }
        endIndex = index
        return emoteRanges
    }
    
    private func emoteInfo(from string: String.SubSequence, endIndex: inout String.Index) -> (emoteId: Int?, positionRanges: [ClosedRange<Int>]) {
        var emoteIdString = ""
        var emoteIndicies = [ClosedRange<Int>]()
        var index = string.startIndex
        
        outerWhile: while index < string.endIndex {
            let currentCharacter = string[index]
            index = string.index(after: index)
            
            switch currentCharacter {
            case ":":
                emoteIndicies = emotePositionRanges(from: string[index...], endIndex: &index)
                break outerWhile
            default:
                emoteIdString.append(currentCharacter)
            }
        }
        endIndex = index
        return (Int(emoteIdString), emoteIndicies)
    }
    
    private func sortEmotePositions(_ emotesInfo: [(emoteId: Int, positionRanges: [ClosedRange<Int>])]) -> Emotes {
        var emotesInfoPositionIndicies = Array(repeating: 0, count: emotesInfo.count)
        var counter = 0
        var emotePositionToId = [Int: Int]()
        var emotePositions = [ClosedRange<Int>]()
        let totalInsertions = emotesInfo.reduce(0) { $1.positionRanges.count + $0 }
       
        while counter < totalInsertions {
            let lowerBounds = emotesInfoPositionIndicies.enumerated().map {
                ($0.offset, emotesInfo[$0.offset].positionRanges.count > $0.element ? emotesInfo[$0.offset].positionRanges[$0.element].lowerBound : Int.max)
            }
            if let minBound = lowerBounds.min(by: { $0.1 < $1.1 }) {
                emotePositionToId[emotePositions.count] = emotesInfo[minBound.0].emoteId
                emotePositions.append(emotesInfo[minBound.0].positionRanges[emotesInfoPositionIndicies[minBound.0]])
                emotesInfoPositionIndicies[minBound.0] += 1
            }
            
            counter += 1
        }
        
        return Emotes(ranges: emotePositions, emotes: emotePositionToId)
    }
    
    private func emotes(from string: String.SubSequence, endIndex: inout String.Index) -> SocketMessageTag.Value? {
        var index = string.startIndex
        var emotesInfo = [(emoteId: Int, positionRanges: [ClosedRange<Int>])]()
        
        while index < string.endIndex {
            let (emoteId, emotePositionRanges) = emoteInfo(from: string[index...], endIndex: &index)
            if let emoteId = emoteId {
                emotesInfo.append((emoteId, emotePositionRanges))
            }
            if string[string.index(before: index)] == ";" {
                break
            }
        }
        
        guard !emotesInfo.isEmpty else { return nil }
        
        return .emotes(sortEmotePositions(emotesInfo))
    }
    
    private func integer(from string: String.SubSequence, endIndex: inout String.Index) -> SocketMessageTag.Value? {
        if case .string(let value) = self.string(from: string, endIndex: &endIndex) {
            return Int(value).flatMap { SocketMessageTag.Value.integer($0) }
        } else {
            return nil
        }
    }
    
    private func hexColor(from string: String.SubSequence, endIndex: inout String.Index) -> SocketMessageTag.Value? {
        if case .string(let value) = self.string(from: string, endIndex: &endIndex) {
            return colorComponents(from: value).flatMap { SocketMessageTag.Value.color($0) }
        } else {
            return nil
        }
    }
    
    func value(for tag: SocketMessageTag, from string: String.SubSequence, endIndex: inout String.Index) -> SocketMessageTag.Value? {
        switch tag {
        case .color:
            return hexColor(from: string, endIndex: &endIndex)
        case .displayName:
            return self.string(from: string, endIndex: &endIndex)
        case .emotes:
            return emotes(from: string, endIndex: &endIndex)
        case .timestamp:
            return integer(from: string, endIndex: &endIndex)
        }
    }
}

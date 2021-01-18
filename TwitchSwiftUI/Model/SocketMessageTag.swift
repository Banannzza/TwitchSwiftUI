//
//  SocketMessageTag.swift
//  TwitchChat
//
//  Created by Aleksey Ostapenko on 02.01.2021.
//

import Foundation

enum SocketMessageTag: String {
    case color = "color"
    case displayName = "display-name"
    case emotes = "emotes"
    case timestamp = "tmi-sent-ts"
    
    enum Value {
        case string(String)
        case color(ColorComponents)
        case integer(Int)
        case emotes(Emotes)
    }
}

extension Dictionary where Self.Key == SocketMessageTag, Self.Value == SocketMessageTag.Value {
    var color: ColorComponents? {
        if case let .color(color) = self[.color] {
            return color
        }
        return nil
    }
    
    var displayName: String? {
        if case let .string(string) = self[.displayName] {
            return string
        }
        return nil
    }
    
    var emotes: Emotes {
        if case let .emotes(emotes) = self[.emotes] {
            return emotes
        }
        return Emotes()
    }
    
    var timestamp: Int? {
        if case let .integer(integer) = self[.timestamp] {
            return integer
        }
        return nil
    }
}

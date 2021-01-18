//
//  TagValueParser.swift
//  TwitchChat
//
//  Created by Aleksey Ostapenko on 02.01.2021.
//

import Foundation

protocol TagValueParser {
    func value(for tag: SocketMessageTag, from string: String.SubSequence, endIndex: inout String.Index) -> SocketMessageTag.Value?
}

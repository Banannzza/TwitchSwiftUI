//
//  TagParser.swift
//  TwitchChat
//
//  Created by Aleksey Ostapenko on 02.01.2021.
//

import Foundation

protocol TagParser {
    func tags(from string: String.SubSequence, startIndex: String.Index, endIndex: inout String.Index) -> [SocketMessageTag: SocketMessageTag.Value]
}

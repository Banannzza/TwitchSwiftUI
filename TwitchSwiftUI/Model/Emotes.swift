//
//  Emotes.swift
//  TwitchChat
//
//  Created by Aleksey Ostapenko on 02.01.2021.
//

import Foundation

struct Emotes {
    let ranges: [ClosedRange<Int>]
    let emotes: [Int: Int]
    
    init(ranges: [ClosedRange<Int>] = [], emotes: [Int : Int] = [:]) {
        self.ranges = ranges
        self.emotes = emotes
    }
    
    var isEmpty: Bool { ranges.isEmpty }
    var isNotEmpty: Bool { !isEmpty }
}

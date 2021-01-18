//
//  Array.swift
//  Scorpio
//
//  Created by Aleksey Ostapenko on 10.01.2021.
//

import Foundation

extension Array {
    func element(at index: Index) -> Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
}

//
//  ImageCache.swift
//  Twitch
//
//  Created by Aleksey Ostapenko on 14.01.2021.
//

import Foundation
import UIKit
import Combine

final class ImageCache<Key> where Key: Hashable {

    enum Policy {
        case forever
        case time(TimeInterval)
    }
    
    private var storage = [Key: Data]()
    private var deleteTickets = [Key: Date]()
    private let workQueue = DispatchQueue(label: "com.imageCache", attributes: .concurrent)
 
    private func deleteTicket(for key: Key, policy: Policy) {
        guard case let .time(timeInterval) = policy else {
            deleteTickets[key] = nil
            return
        }
        
        deleteTickets[key] = Date().addingTimeInterval(timeInterval)
    }
    
    func data(for key: Key) -> Data? {
        var value: Data? = nil
        workQueue.sync {
            if let deleteDate = deleteTickets[key], deleteDate > Date() {
                storage[key] = nil
                deleteTickets[key] = nil
            }
            value = storage[key]
        }
        return value
    }
    
    func save(_ data: Data, for key: Key, with policy: Policy = .forever) {
        workQueue.async(flags: .barrier) { [weak self] in
            self?.deleteTicket(for: key, policy: policy)
            self?.storage[key] = data
        }
    }
}


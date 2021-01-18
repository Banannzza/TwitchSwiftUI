//
//  AsyncStorage.swift
//  AsyncStorage
//
//  Created by adostapenko on 08.01.2021.
//

import Foundation
import Combine

extension DispatchQueue {
    func syncValue<Value>(execute closure: () -> (Value)) -> Value {
        var value: Value!
        sync {
            value = closure()
        }
        return value
    }
}

final class AsyncStorage<Key: Hashable, Data> {
    
    private let syncQueue = DispatchQueue(label: "com.asyncStorage.queue", attributes: .concurrent)
    private var storage = [Key: AnyPublisher<Data, Error>]()
    private var disposeBag = Set<AnyCancellable>()

    func request<E>(_ publisher: AnyPublisher<Data, E>, withKey key: Key) -> AnyPublisher<Data, Error> {
        syncQueue.syncValue(execute: { storage[key] }) ?? self.publisher(publisher, withKey: key)
    }

    private func publisher<E>(_ publisher: AnyPublisher<Data, E>, withKey key: Key) -> AnyPublisher<Data, Error> {
        let publisher = Future<Data, Error>{ promise in
            publisher.sink { [weak self] completion in
                guard let self = self else { return }
                
                if case let .failure(error) = completion {
                    self.syncQueue.async(flags: .barrier) {
                        self.storage.removeValue(forKey: key)
                    }
                    promise(.failure(error))
                }
            } receiveValue: { [weak self] data in
                guard let self = self else { return }
                
                self.syncQueue.async(flags: .barrier) { self.storage[key] = Result.Publisher(data).eraseToAnyPublisher() }
                promise(.success(data))
            }
            .store(in: &self.disposeBag)
        }
        .eraseToAnyPublisher()
        
        syncQueue.async(flags: .barrier) {
            self.storage[key] = publisher
        }
        
        return publisher
    }
}

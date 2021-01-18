//
//  WKViewStorage.swift
//  Twitch
//
//  Created by Aleksey Ostapenko on 17.01.2021.
//

import WebKit

final class WKViewStorage {
    private var storage = NSHashTable<WKWebView>(options: .weakMemory)
    private var requestToAddress = [URLRequest: UnsafeMutableRawPointer]()
    
    func get(for request: URLRequest) -> WKWebView? {
        guard let address = requestToAddress[request] else { return nil }
        
        if let webView = storage.allObjects.first(where: { Unmanaged.passUnretained($0).toOpaque() == address }) {
            return webView
        }
        requestToAddress[request] = nil
        return nil
    }
    
    func save(_ webView: WKWebView, for request: URLRequest) {
        let address = Unmanaged.passUnretained(webView).toOpaque()
        requestToAddress[request] = address
        storage.add(webView)
    }
    
    func contains(with request: URLRequest) -> Bool {
        get(for: request) != nil
    }
}

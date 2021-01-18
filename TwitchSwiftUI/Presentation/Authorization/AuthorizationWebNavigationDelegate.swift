//
//  AuthorizationWebNavigationDelegate.swift
//  Twitch
//
//  Created by Aleksey Ostapenko on 16.01.2021.
//

import SwiftUI
import WebKit

final class AuthorizationWebNavigationDelegate: NSObject, WebNavigationDelegate {
    let redirectClosure: ((URL) -> ())?
    let redirectHost: String?
    @Binding var webView: WKWebView?
        
    init(
        redirectClosure: ((URL) -> ())?,
        redirectHost: String?,
        webView: Binding<WKWebView?> = .constant(nil)) {
        self.redirectHost = redirectHost
        self.redirectClosure = redirectClosure
        self._webView = webView
    }

    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard
            let url = navigationAction.request.url,
            url.host == redirectHost?.lowercased()
        else {
            decisionHandler(.allow)
            return
        }
        
        redirectClosure?(url)
        decisionHandler(.cancel)
    }
}

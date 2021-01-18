//
//  WebVideoNavgation.swift
//  Twitch
//
//  Created by Aleksey Ostapenko on 16.01.2021.
//

import WebKit
import SwiftUI

final class WebVideoNavgation: NSObject, WebNavigationDelegate {
    @Binding var webView: WKWebView?
    
    init(_ webView: Binding<WKWebView?>) {
        self._webView = webView
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.webView = webView
    }
}


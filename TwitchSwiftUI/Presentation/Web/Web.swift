//
//  WebView.swift
//  TwitchApi
//
//  Created by adostapenko on 11.01.2021.
//

import SwiftUI
import WebKit

protocol WebNavigationDelegate: WKNavigationDelegate {
    var webView: WKWebView? { get set }
}

struct Web: UIViewRepresentable {
    
    let request: URLRequest
    let delegate: WebNavigationDelegate?
    
    init(request: URLRequest, delegate: WebNavigationDelegate? = nil) {
        self.request = request
        self.delegate = delegate
    }
    
    var webConfiguration: WKWebViewConfiguration {
        let scriptSource = """
            var meta = document.createElement('meta');
            meta.name = 'viewport';
            meta.content = 'width=device-width, height=device-height, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
            var head = document.getElementsByTagName('head')[0];
            head.appendChild(meta);
        """
        
        let script: WKUserScript = WKUserScript(source: scriptSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let userContentController: WKUserContentController = WKUserContentController()
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        userContentController.addUserScript(script)
        return configuration
    }
    
    func makeUIView(context: Context) -> WKWebView {
        if let oldView = context.environment.wkViewStorage.get(for: request) {
            oldView.navigationDelegate = delegate
            delegate?.webView = oldView
            return oldView
        }
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.alwaysBounceVertical = false
        webView.isOpaque = true
        webView.backgroundColor = UIColor.black
        webView.scrollView.backgroundColor = UIColor.black
        webView.navigationDelegate = delegate
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.load(request)
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if !context.environment.wkViewStorage.contains(with: request) {
            context.environment.wkViewStorage.save(uiView, for: request)
        }
    }
}

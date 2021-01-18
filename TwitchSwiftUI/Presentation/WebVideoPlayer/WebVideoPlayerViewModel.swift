//
//  WebVideoPlayerViewModel.swift
//  Twitch
//
//  Created by Aleksey Ostapenko on 16.01.2021.
//

import SwiftUI
import WebKit
import Combine

final class WebVideoPlayerViewModel: ObservableObject {
    @Published var webView: WKWebView?
    @Published var isMuted = false
    @Published var isPaused = false
    @Published var controlsHidden = true
    @Published var pipActivated = false
    
    private let videoJavaScriptor = VideoPlayerJavaScriptor()
    private var disposeBag = Set<AnyCancellable>()
    private var hidePublisher: AnyCancellable?
    
    init() {
        _webView.projectedValue.sink { [weak self] view in
            guard let self = self, view != nil else { return }
            view?.evaluateJavaScript(self.videoJavaScriptor.hideDefaultPlayer())
            self.showControls()
            self.delayControlsHidePublisher()
        }
        .store(in: &disposeBag)
        
        _isMuted.projectedValue.sink { [weak self] in
            guard let self = self else { return }
            self.evaluateScript(self.videoJavaScriptor.setMuted($0))
        }
        .store(in: &disposeBag)
        
        _isPaused.projectedValue.sink { [weak self] in
            guard let self = self else { return }
            self.evaluateScript(self.videoJavaScriptor.setPaused($0))
        }
        .store(in: &disposeBag)
        
        _controlsHidden.projectedValue.sink { [weak self] hidden in
            guard !hidden else { return }
            self?.hideControls()
        }
        .store(in: &disposeBag)
    }
    
    func pipRequest() {
        webView?.evaluateJavaScript(videoJavaScriptor.pipRequest())
        pipActivated.toggle()
        hideControls(withDelay: false)
    }
    
    func airplayRequest() {
        evaluateScript(videoJavaScriptor.airplayRequest())
    }
    
    private func evaluateScript(_ script: String, shouldHideControls: Bool = true) {
        webView?.evaluateJavaScript(script) 
        if shouldHideControls {
            hideControls()
        }
    }
    
    private func delayControlsHidePublisher() {
        hidePublisher = Just(true)
            .delay(for: .seconds(2), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.controlsHidden = true
            })
    }
    
    private func hideControls(withDelay: Bool = true) {
        guard webView != nil else { return }
        if withDelay {
            delayControlsHidePublisher()
        } else {
            hidePublisher = nil
            controlsHidden = true
        }
    }
    
    func showControls() {
        hidePublisher = nil
        controlsHidden = false
    }
    
    func enterFullscreen() {
        evaluateScript(videoJavaScriptor.enterFullscreen())
    }
}

//
//  WebViewViewportManager.swift
//  TradePulse
//

import Foundation
import WebKit

@objc final class WebViewViewportManager: NSObject {
    @objc static let shared = WebViewViewportManager()
    
    var currentUserScript: WKUserScript?

    @objc func setViewportWithScale(_ scale: CGFloat, width: CGFloat, webView: WKWebView?) {
        // no-op stub for compatibility
    }
    
    @objc func handleUrl(_ url: URL, query: [AnyHashable: Any], webView: WKWebView?, completion: @escaping ([AnyHashable : Any]) -> Void) {
        completion([:])
    }

    @objc func getViewportScale(webView: WKWebView?, completion: @escaping ([AnyHashable : Any]) -> Void) {
        completion(["zoom": 1])
    }

    @objc func setViewport(scale: NSNumber?, width: NSNumber?, webView: WKWebView?) {
        // no-op
    }

    @objc func updateViewport() {
        // no-op
    }
}

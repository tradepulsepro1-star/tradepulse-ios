//
//  WebViewViewportManager.swift
//  MedianIOS
//
//  Created by Kevz on 1/16/26.
//  Copyright © 2026 GoNative.io LLC. All rights reserved.
//
//  NOTE: GoNativeCore package removed — viewport manager stubbed with pure WebKit implementation.

import WebKit
import UIKit

@objc final class WebViewViewportManager: NSObject {
    @objc static let shared = WebViewViewportManager()

    var currentUserScript: WKUserScript?

    @objc func handleUrl(_ url: URL, query: [AnyHashable: Any], webView: WKWebView?, completion: @escaping ([AnyHashable: Any]) -> Void) {
        if url.path.hasPrefix("/getZoom") {
            getViewportScale(webView: webView, completion: completion)
        } else if url.path == "/setZoom" {
            if let zoom = query["zoom"] as? NSNumber {
                setViewport(scale: zoom, width: nil, webView: webView)
                completion(["success": true])
            } else {
                completion(["success": false, "error": "Invalid zoom value"])
            }
        }
    }

    @objc func getViewportScale(webView: WKWebView?, completion: @escaping ([AnyHashable: Any]) -> Void) {
        let javascript = """
            (function() {
                var meta = document.querySelector('meta[name=viewport]');
                if (!meta) return null;
                var content = meta.getAttribute('content');
                if (!content) return null;
                var match = content.match(/initial-scale\\s*=\\s*([0-9\\.]+)/);
                return match ? parseFloat(match[1]) : null;
            })();
        """
        webView?.evaluateJavaScript(javascript) { result, error in
            guard error == nil, let value = result as? NSNumber else {
                completion(["zoom": 1])
                return
            }
            completion(["zoom": CGFloat(truncating: value)])
        }
    }

    @objc func setViewport(scale: NSNumber?, width: NSNumber?, webView: WKWebView?) {
        // Default: allow user scaling (pinchToZoom = true)
        let pinchToZoom = true
        var scaleContent = ""
        var widthContent = ""
        var zoom = 0.0

        if let scale = scale, scale.doubleValue > 0 {
            let initialScale = String(format: "%.3f", scale.doubleValue)
            scaleContent = "initial-scale=\(initialScale)"
            zoom = scale.doubleValue
        } else if let width = width {
            widthContent = "width=\(width)"
        }

        let userScalable = pinchToZoom ? "yes" : "no"
        let javascript: String

        if !scaleContent.isEmpty {
            let w = zoom > 0 ? UIScreen.main.bounds.width / CGFloat(zoom) : UIScreen.main.bounds.width
            javascript = """
            (function() {
                var meta = document.querySelector('meta[name=viewport]') || document.createElement('meta');
                meta.name = 'viewport';
                document.head.appendChild(meta);
                meta.setAttribute('content', 'width=\(w),\(scaleContent),user-scalable=\(userScalable)');
            })();
            """
        } else if !widthContent.isEmpty {
            javascript = """
            (function() {
                var meta = document.querySelector('meta[name=viewport]') || document.createElement('meta');
                meta.name = 'viewport';
                document.head.appendChild(meta);
                meta.setAttribute('content', '\(widthContent),user-scalable=\(userScalable)');
            })();
            """
        } else {
            javascript = """
            (function() {
                var meta = document.querySelector('meta[name=viewport]') || document.createElement('meta');
                meta.name = 'viewport';
                document.head.appendChild(meta);
                var existing = meta.getAttribute('content') || '';
                meta.setAttribute('content', existing ? existing + ',user-scalable=\(userScalable)' : 'user-scalable=\(userScalable)');
            })();
            """
        }

        updateCurrentScript(javascript, webView: webView)
    }

    private func updateCurrentScript(_ javascript: String, webView: WKWebView?) {
        guard let webView = webView else { return }
        webView.evaluateJavaScript(javascript, completionHandler: nil)
        let newScript = WKUserScript(source: javascript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        var userScripts = webView.configuration.userContentController.userScripts
        if let currentUserScript = currentUserScript {
            userScripts.removeAll(where: { $0 == currentUserScript })
            webView.configuration.userContentController.removeAllUserScripts()
            for userScript in userScripts {
                webView.configuration.userContentController.addUserScript(userScript)
            }
        }
        webView.configuration.userContentController.addUserScript(newScript)
        currentUserScript = newScript
    }
}

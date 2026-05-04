//
//  WebViewViewportManager.swift
//  TradePulse
//

import Foundation
import WebKit

@objc public final class WebViewViewportManager: NSObject {
    @objc static let shared = WebViewViewportManager()

    private var currentUserScript: WKUserScript?

    @objc func setViewportWithScale(_ scale: CGFloat, width: NSNumber?, webView: WKWebView?) {
        var scaleContent = ""
        var widthContent = ""
        var zoom = 0.0

        if scale > 0 {
            let s = String(format: "%.3f", scale)
            scaleContent = "initial-scale=\(s)"
            zoom = scale
        } else if let width = width {
            widthContent = "width=\(width)"
        }

        let js: String
        if !scaleContent.isEmpty {
            js = """
            (function(){
                var m=document.querySelector('meta[name=viewport]');
                if(!m){m=document.createElement('meta');m.name='viewport';document.head.appendChild(m);}
                var w=window.screen.width/\(zoom);
                m.setAttribute('content','width='+w+',\(scaleContent),user-scalable=no');
            })();
            """
        } else if !widthContent.isEmpty {
            js = """
            (function(){
                var m=document.querySelector('meta[name=viewport]');
                if(!m){m=document.createElement('meta');m.name='viewport';document.head.appendChild(m);}
                m.setAttribute('content','\(widthContent),user-scalable=no');
            })();
            """
        } else {
            return
        }
        updateScript(js, webView: webView)
    }

    @objc(setViewportScale:width:webView:)
    func setViewport(scale: NSNumber?, width: NSNumber?, webView: WKWebView?) {
        let s = scale != nil ? CGFloat(truncating: scale!) : 0
        setViewportWithScale(s, width: width, webView: webView)
    }

    @objc func handleUrl(_ url: URL, query: [AnyHashable: Any], webView: WKWebView?,
                         completion: @escaping ([AnyHashable: Any]) -> Void) {
        if url.path == "/setZoom", let z = query["zoom"] as? NSNumber {
            setViewport(scale: z, width: nil, webView: webView)
        }
        completion([:])
    }

    @objc func getViewportScale(webView: WKWebView?, completion: @escaping ([AnyHashable: Any]) -> Void) {
        completion(["zoom": 1])
    }

    @objc func updateViewport() {}

    private func updateScript(_ js: String, webView: WKWebView?) {
        guard let webView = webView else { return }
        webView.evaluateJavaScript(js, completionHandler: nil)
        let newScript = WKUserScript(source: js, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        if let old = currentUserScript {
            var scripts = webView.configuration.userContentController.userScripts
            scripts.removeAll { $0 == old }
            webView.configuration.userContentController.removeAllUserScripts()
            scripts.forEach { webView.configuration.userContentController.addUserScript($0) }
        }
        webView.configuration.userContentController.addUserScript(newScript)
        currentUserScript = newScript
    }
}

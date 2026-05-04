import UIKit
import WebKit

class DeepLinkManager {

    static func handleDeepLink(url: URL, webView: WKWebView) {
        // Handles both custom scheme: tradepulse://guru/123
        // and universal links: https://tradepulsepro.net/guru/123
        let urlString = url.absoluteString
        let js = "window.TradePulseNative && window.TradePulseNative.deepLink && window.TradePulseNative.deepLink.handle('\(urlString)')"
        webView.evaluateJavaScript(js, completionHandler: nil)
    }

    static func handleUniversalLink(userActivity: NSUserActivity, webView: WKWebView) {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let url = userActivity.webpageURL else { return }
        handleDeepLink(url: url, webView: webView)
    }

    // Routes:
    // tradepulse://guru/{userId}       → /guru/{userId}
    // tradepulse://signal/{signalId}   → /signal/{signalId}
    // tradepulse://ticker/{ticker}     → /ticker/{ticker}
    // tradepulse://community/{ticker}  → /community/{ticker}
    static func resolveRoute(from url: URL) -> String? {
        guard let host = url.host else { return nil }
        let path = url.pathComponents.dropFirst().joined(separator: "/")

        switch host {
        case "guru":       return "/guru/\(path)"
        case "signal":     return "/signal/\(path)"
        case "ticker":     return "/ticker/\(path)"
        case "community":  return "/community/\(path)"
        default:           return nil
        }
    }
}

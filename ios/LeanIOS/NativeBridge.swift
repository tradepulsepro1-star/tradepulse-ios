import UIKit
import WebKit

/// Handles all JavaScript → Native bridge calls from the web app
class NativeBridge: NSObject, WKScriptMessageHandler {
    
    weak var webView: WKWebView?
    weak var viewController: UIViewController?
    
    init(webView: WKWebView, viewController: UIViewController) {
        self.webView = webView
        self.viewController = viewController
        super.init()
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let body = message.body as? [String: Any],
              let action = body["action"] as? String else { return }
        
        let callback = body["callback"] as? String ?? "console.log"
        
        switch action {
            
        // MARK: - Face ID
        case "faceID.check":
            if let wv = webView { FaceIDManager.checkAvailability(webView: wv, callbackName: callback) }
            
        case "faceID.authenticate":
            if let wv = webView { FaceIDManager.authenticate(webView: wv, callbackName: callback) }
            
        // MARK: - App Review
        case "review.request":
            if let wv = webView { AppReviewManager.requestReview(webView: wv) }
            
        // MARK: - Haptics
        case "haptics.impact":
            HapticsManager.impact(style: body["style"] as? String ?? "medium")
            
        case "haptics.notification":
            HapticsManager.notification(type: body["type"] as? String ?? "success")
            
        case "haptics.selection":
            HapticsManager.selection()
            
        // MARK: - Share
        case "share.open":
            if let vc = viewController {
                ShareManager.share(text: body["text"] as? String ?? "", url: body["url"] as? String, viewController: vc)
            }
            
        // MARK: - Camera
        case "camera.pick":
            if let wv = webView, let vc = viewController {
                CameraManager.shared.pickImage(webView: wv, callbackName: callback, viewController: vc, source: body["source"] as? String ?? "library")
            }
            
        // MARK: - Sign in with Apple
        case "auth.apple":
            if let wv = webView, let vc = viewController {
                SignInWithAppleManager.shared.signIn(webView: wv, callbackName: callback, viewController: vc)
            }
            
        // MARK: - Google Sign-In
        case "auth.google":
            if let wv = webView, let vc = viewController {
                GoogleSignInManager.shared.signIn(webView: wv, callbackName: callback, viewController: vc)
            }
            
        default:
            print("[NativeBridge] Unknown action: \(action)")
        }
    }
    
    static func injectedScript() -> String {
        return """
        window.TradePulseNative = {
            isNative: true,
            faceID: {
                check: function(cb) { window.webkit.messageHandlers.nativeBridge.postMessage({ action: 'faceID.check', callback: cb }); },
                authenticate: function(cb) { window.webkit.messageHandlers.nativeBridge.postMessage({ action: 'faceID.authenticate', callback: cb }); }
            },
            review: {
                request: function() { window.webkit.messageHandlers.nativeBridge.postMessage({ action: 'review.request' }); }
            },
            haptics: {
                impact: function(style) { window.webkit.messageHandlers.nativeBridge.postMessage({ action: 'haptics.impact', style: style || 'medium' }); },
                notification: function(type) { window.webkit.messageHandlers.nativeBridge.postMessage({ action: 'haptics.notification', type: type || 'success' }); },
                selection: function() { window.webkit.messageHandlers.nativeBridge.postMessage({ action: 'haptics.selection' }); }
            },
            share: {
                open: function(text, url) { window.webkit.messageHandlers.nativeBridge.postMessage({ action: 'share.open', text: text, url: url }); }
            },
            camera: {
                pick: function(source, cb) { window.webkit.messageHandlers.nativeBridge.postMessage({ action: 'camera.pick', source: source || 'library', callback: cb }); }
            },
            auth: {
                signInWithApple: function(cb) { window.webkit.messageHandlers.nativeBridge.postMessage({ action: 'auth.apple', callback: cb }); },
                signInWithGoogle: function(cb) { window.webkit.messageHandlers.nativeBridge.postMessage({ action: 'auth.google', callback: cb }); }
            }
        };
        console.log('[TradePulse] Native bridge initialized');
        """
    }
}

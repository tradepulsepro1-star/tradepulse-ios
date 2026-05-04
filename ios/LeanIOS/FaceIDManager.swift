import LocalAuthentication
import WebKit

class FaceIDManager {
    static func authenticate(webView: WKWebView, callbackName: String) {
        let context = LAContext()
        var error: NSError?

        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            let js = "\(callbackName)({ success: false, error: 'Biometrics not available' })"
            webView.evaluateJavaScript(js, completionHandler: nil)
            return
        }

        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                               localizedReason: "Authenticate to access TradePulse") { success, error in
            DispatchQueue.main.async {
                if success {
                    let js = "\(callbackName)({ success: true })"
                    webView.evaluateJavaScript(js, completionHandler: nil)
                } else {
                    let msg = error?.localizedDescription ?? "Authentication failed"
                    let js = "\(callbackName)({ success: false, error: '\(msg)' })"
                    webView.evaluateJavaScript(js, completionHandler: nil)
                }
            }
        }
    }

    static func checkAvailability(webView: WKWebView, callbackName: String) {
        let context = LAContext()
        var error: NSError?
        let available = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        let biometryType = context.biometryType

        var typeStr = "none"
        if available {
            switch biometryType {
            case .faceID: typeStr = "faceID"
            case .touchID: typeStr = "touchID"
            default: typeStr = "none"
            }
        }
        let js = "\(callbackName)({ available: \(available), type: '\(typeStr)' })"
        webView.evaluateJavaScript(js, completionHandler: nil)
    }
}

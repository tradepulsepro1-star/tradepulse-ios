import AppTrackingTransparency
import AdSupport
import WebKit

class ATTManager {

    static func requestTracking(webView: WKWebView, callbackName: String) {
        if #available(iOS 14.5, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                DispatchQueue.main.async {
                    let statusStr: String
                    switch status {
                    case .authorized:           statusStr = "authorized"
                    case .denied:               statusStr = "denied"
                    case .restricted:           statusStr = "restricted"
                    case .notDetermined:        statusStr = "notDetermined"
                    @unknown default:           statusStr = "unknown"
                    }
                    let idfa = status == .authorized ? ASIdentifierManager.shared().advertisingIdentifier.uuidString : ""
                    let js = "\(callbackName)({ status: '\(statusStr)', idfa: '\(idfa)' })"
                    webView.evaluateJavaScript(js, completionHandler: nil)
                }
            }
        } else {
            // iOS < 14.5 — tracking allowed by default
            let js = "\(callbackName)({ status: 'authorized', idfa: '' })"
            webView.evaluateJavaScript(js, completionHandler: nil)
        }
    }

    static func getStatus(webView: WKWebView, callbackName: String) {
        if #available(iOS 14, *) {
            let status = ATTrackingManager.trackingAuthorizationStatus
            let statusStr: String
            switch status {
            case .authorized:    statusStr = "authorized"
            case .denied:        statusStr = "denied"
            case .restricted:    statusStr = "restricted"
            case .notDetermined: statusStr = "notDetermined"
            @unknown default:    statusStr = "unknown"
            }
            let js = "\(callbackName)({ status: '\(statusStr)' })"
            webView.evaluateJavaScript(js, completionHandler: nil)
        } else {
            let js = "\(callbackName)({ status: 'authorized' })"
            webView.evaluateJavaScript(js, completionHandler: nil)
        }
    }
}

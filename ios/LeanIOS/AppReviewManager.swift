import StoreKit
import WebKit

class AppReviewManager {
    static func requestReview(webView: WKWebView) {
        DispatchQueue.main.async {
            if let scene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
            webView.evaluateJavaScript("window.median && window.median.review && window.median.review.callback && window.median.review.callback({ success: true })", completionHandler: nil)
        }
    }
}

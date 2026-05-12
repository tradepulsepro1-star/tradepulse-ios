import UIKit
import WebKit

class PullToRefreshManager {

    private var refreshControl: UIRefreshControl?
    private weak var webView: WKWebView?

    init(webView: WKWebView, scrollView: UIScrollView) {
        self.webView = webView
        let rc = UIRefreshControl()
        rc.tintColor = UIColor(red: 245/255, green: 200/255, blue: 66/255, alpha: 1) // Gold #F5C842
        rc.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        scrollView.addSubview(rc)
        scrollView.bounces = true
        self.refreshControl = rc
    }

    @objc private func handleRefresh() {
        // Notify web app and reload
        webView?.evaluateJavaScript("window.TradePulseNative && window.TradePulseNative.onRefresh && window.TradePulseNative.onRefresh()") { [weak self] _, _ in
            // End refresh after short delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self?.refreshControl?.endRefreshing()
            }
        }
        // Also reload the webview if JS handler not present
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.webView?.reload()
        }
    }

    func endRefreshing() {
        refreshControl?.endRefreshing()
    }
}

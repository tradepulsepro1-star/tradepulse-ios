import Foundation
import Security
import WebKit

class KeychainManager {

    static func save(key: String, value: String) -> Bool {
        let data = value.data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String:       kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecAttrService as String: "net.tradepulsepro",
            kSecValueData as String:   data
        ]
        SecItemDelete(query as CFDictionary) // Remove old value first
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    static func get(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String:       kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecAttrService as String: "net.tradepulsepro",
            kSecReturnData as String:  true,
            kSecMatchLimit as String:  kSecMatchLimitOne
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess, let data = result as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }

    static func delete(key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String:       kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecAttrService as String: "net.tradepulsepro"
        ]
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }

    static func clear() {
        let query: [String: Any] = [
            kSecClass as String:       kSecClassGenericPassword,
            kSecAttrService as String: "net.tradepulsepro"
        ]
        SecItemDelete(query as CFDictionary)
    }

    // Bridge methods for WebView
    static func saveFromJS(webView: WKWebView, key: String, value: String, callbackName: String) {
        let success = save(key: key, value: value)
        webView.evaluateJavaScript("\(callbackName)({ success: \(success) })", completionHandler: nil)
    }

    static func getFromJS(webView: WKWebView, key: String, callbackName: String) {
        let value = get(key: key) ?? ""
        let found = !value.isEmpty
        webView.evaluateJavaScript("\(callbackName)({ found: \(found), value: '\(value)' })", completionHandler: nil)
    }

    static func deleteFromJS(webView: WKWebView, key: String, callbackName: String) {
        let success = delete(key: key)
        webView.evaluateJavaScript("\(callbackName)({ success: \(success) })", completionHandler: nil)
    }
}

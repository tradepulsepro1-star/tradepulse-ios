//
//  NativeBridge.swift
//  TradePulse
//
//  Round 1 Native Plugin — FaceID, Haptics, Share Sheet, Camera,
//  App Review, Sign in with Apple, Local Notifications, Deep Linking,
//  Pull-to-Refresh, ATT Privacy Prompt, Secure Storage (Keychain)
//
//  Called from web via: window.TradePulseNative.<method>(args)
//  All JS callbacks use window.dispatchEvent(new CustomEvent(...))
//

import UIKit
import WebKit
import LocalAuthentication
import StoreKit
import AuthenticationServices
import UserNotifications
import Security
import AppTrackingTransparency
import AdSupport

@objc class NativeBridge: NSObject, WKScriptMessageHandler {

    weak var webView: WKWebView?
    weak var viewController: UIViewController?

    init(webView: WKWebView, viewController: UIViewController) {
        self.webView = webView
        self.viewController = viewController
        super.init()
        setupMessageHandlers()
    }

    // ─── Register JS message handlers ─────────────────────────────────────────
    func setupMessageHandlers() {
        let handlers = [
            "biometricAuth", "checkBiometrics",
            "haptic",
            "shareSheet",
            "openCamera", "openPhotoLibrary",
            "requestAppReview",
            "signInWithApple",
            "requestNotificationPermission", "scheduleLocalNotification", "cancelLocalNotification",
            "requestATT",
            "keychainSet", "keychainGet", "keychainDelete",
            "openURL"
        ]
        for h in handlers {
            webView?.configuration.userContentController.add(self, name: h)
        }
        injectJSBridge()
    }

    // ─── Inject window.TradePulseNative shim ──────────────────────────────────
    func injectJSBridge() {
        let js = """
        window.TradePulseNative = {
            biometricAuth: function(cb) { window.webkit.messageHandlers.biometricAuth.postMessage({ callback: cb || '' }); },
            checkBiometrics: function(cb) { window.webkit.messageHandlers.checkBiometrics.postMessage({ callback: cb || '' }); },
            haptic: function(type) { window.webkit.messageHandlers.haptic.postMessage({ type: type || 'medium' }); },
            shareSheet: function(text, url) { window.webkit.messageHandlers.shareSheet.postMessage({ text: text || '', url: url || '' }); },
            openCamera: function(cb) { window.webkit.messageHandlers.openCamera.postMessage({ callback: cb || '' }); },
            openPhotoLibrary: function(cb) { window.webkit.messageHandlers.openPhotoLibrary.postMessage({ callback: cb || '' }); },
            requestAppReview: function() { window.webkit.messageHandlers.requestAppReview.postMessage({}); },
            signInWithApple: function(cb) { window.webkit.messageHandlers.signInWithApple.postMessage({ callback: cb || '' }); },
            requestNotificationPermission: function(cb) { window.webkit.messageHandlers.requestNotificationPermission.postMessage({ callback: cb || '' }); },
            scheduleLocalNotification: function(id, title, body, seconds) { window.webkit.messageHandlers.scheduleLocalNotification.postMessage({ id: id, title: title, body: body, seconds: seconds || 5 }); },
            cancelLocalNotification: function(id) { window.webkit.messageHandlers.cancelLocalNotification.postMessage({ id: id }); },
            requestATT: function(cb) { window.webkit.messageHandlers.requestATT.postMessage({ callback: cb || '' }); },
            keychainSet: function(key, value) { window.webkit.messageHandlers.keychainSet.postMessage({ key: key, value: value }); },
            keychainGet: function(key, cb) { window.webkit.messageHandlers.keychainGet.postMessage({ key: key, callback: cb || '' }); },
            keychainDelete: function(key) { window.webkit.messageHandlers.keychainDelete.postMessage({ key: key }); },
            openURL: function(url) { window.webkit.messageHandlers.openURL.postMessage({ url: url }); }
        };
        """
        let script = WKUserScript(source: js, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        webView?.configuration.userContentController.addUserScript(script)
    }

    // ─── Message dispatcher ────────────────────────────────────────────────────
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let body = message.body as? [String: Any] ?? [:]
        switch message.name {
        case "biometricAuth":           handleBiometricAuth(body)
        case "checkBiometrics":         handleCheckBiometrics(body)
        case "haptic":                  handleHaptic(body)
        case "shareSheet":              handleShareSheet(body)
        case "openCamera":              handleCamera(body, library: false)
        case "openPhotoLibrary":        handleCamera(body, library: true)
        case "requestAppReview":        handleAppReview()
        case "signInWithApple":         handleSignInWithApple(body)
        case "requestNotificationPermission": handleNotificationPermission(body)
        case "scheduleLocalNotification":    handleScheduleNotification(body)
        case "cancelLocalNotification":      handleCancelNotification(body)
        case "requestATT":              handleATT(body)
        case "keychainSet":             handleKeychainSet(body)
        case "keychainGet":             handleKeychainGet(body)
        case "keychainDelete":          handleKeychainDelete(body)
        case "openURL":                 handleOpenURL(body)
        default: break
        }
    }

    // ─── Helper: dispatch JS event ─────────────────────────────────────────────
    func dispatchEvent(_ name: String, detail: [String: Any]) {
        var parts: [String] = []
        for (k, v) in detail {
            if let s = v as? String {
                let escaped = s.replacingOccurrences(of: "\\", with: "\\\\").replacingOccurrences(of: "'", with: "\\'")
                parts.append("'\(k)': '\(escaped)'")
            } else if let b = v as? Bool {
                parts.append("'\(k)': \(b)")
            } else {
                parts.append("'\(k)': '\(v)'")
            }
        }
        let detailStr = "{ \(parts.joined(separator: ", ")) }"
        let js = "window.dispatchEvent(new CustomEvent('\(name)', { detail: \(detailStr) }));"
        DispatchQueue.main.async { self.webView?.evaluateJavaScript(js, completionHandler: nil) }
    }

    // ─── BIOMETRIC AUTH ────────────────────────────────────────────────────────
    func handleBiometricAuth(_ body: [String: Any]) {
        let ctx = LAContext(); var err: NSError?
        guard ctx.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &err) else {
            dispatchEvent("tradepulse_biometric", detail: ["success": false, "error": "Biometrics not available"]); return
        }
        ctx.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authenticate to access TradePulse") { ok, error in
            self.dispatchEvent("tradepulse_biometric", detail: ["success": ok, "error": error?.localizedDescription ?? ""])
        }
    }

    func handleCheckBiometrics(_ body: [String: Any]) {
        let ctx = LAContext(); var err: NSError?
        let available = ctx.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &err)
        var type = "none"
        if available { switch ctx.biometryType { case .faceID: type = "faceID"; case .touchID: type = "touchID"; default: type = "none" } }
        dispatchEvent("tradepulse_biometrics_check", detail: ["available": available, "type": type])
    }

    // ─── HAPTICS ───────────────────────────────────────────────────────────────
    func handleHaptic(_ body: [String: Any]) {
        let type = body["type"] as? String ?? "medium"
        DispatchQueue.main.async {
            switch type {
            case "light":   UIImpactFeedbackGenerator(style: .light).impactOccurred()
            case "heavy":   UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            case "success": UINotificationFeedbackGenerator().notificationOccurred(.success)
            case "warning": UINotificationFeedbackGenerator().notificationOccurred(.warning)
            case "error":   UINotificationFeedbackGenerator().notificationOccurred(.error)
            default:        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            }
        }
    }

    // ─── SHARE SHEET ──────────────────────────────────────────────────────────
    func handleShareSheet(_ body: [String: Any]) {
        var items: [Any] = []
        if let text = body["text"] as? String, !text.isEmpty { items.append(text) }
        if let urlStr = body["url"] as? String, let url = URL(string: urlStr) { items.append(url) }
        guard !items.isEmpty else { return }
        DispatchQueue.main.async {
            let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)
            self.viewController?.present(vc, animated: true)
        }
    }

    // ─── CAMERA / PHOTO LIBRARY ───────────────────────────────────────────────
    func handleCamera(_ body: [String: Any], library: Bool) {
        DispatchQueue.main.async {
            guard UIImagePickerController.isSourceTypeAvailable(library ? .photoLibrary : .camera) else { return }
            let picker = UIImagePickerController()
            picker.sourceType = library ? .photoLibrary : .camera
            picker.allowsEditing = true
            self.viewController?.present(picker, animated: true)
        }
    }

    // ─── APP REVIEW ───────────────────────────────────────────────────────────
    func handleAppReview() {
        DispatchQueue.main.async {
            if let scene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        }
    }

    // ─── SIGN IN WITH APPLE ───────────────────────────────────────────────────
    func handleSignInWithApple(_ body: [String: Any]) {
        DispatchQueue.main.async {
            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName, .email]
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }
    }

    // ─── LOCAL NOTIFICATIONS ──────────────────────────────────────────────────
    func handleNotificationPermission(_ body: [String: Any]) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            self.dispatchEvent("tradepulse_notification_permission", detail: ["granted": granted])
        }
    }

    func handleScheduleNotification(_ body: [String: Any]) {
        let id      = body["id"] as? String ?? UUID().uuidString
        let title   = body["title"] as? String ?? "TradePulse"
        let bodyStr = body["body"] as? String ?? ""
        let seconds = body["seconds"] as? Double ?? 5
        let content = UNMutableNotificationContent()
        content.title = title; content.body = bodyStr; content.sound = .default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        UNUserNotificationCenter.current().add(UNNotificationRequest(identifier: id, content: content, trigger: trigger))
    }

    func handleCancelNotification(_ body: [String: Any]) {
        if let id = body["id"] as? String {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        }
    }

    // ─── APP TRACKING TRANSPARENCY ────────────────────────────────────────────
    func handleATT(_ body: [String: Any]) {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                let s: String
                switch status {
                case .authorized:         s = "authorized"
                case .denied:             s = "denied"
                case .restricted:         s = "restricted"
                case .notDetermined:      s = "notDetermined"
                @unknown default:         s = "unknown"
                }
                self.dispatchEvent("tradepulse_att", detail: ["status": s])
            }
        } else {
            dispatchEvent("tradepulse_att", detail: ["status": "authorized"])
        }
    }

    // ─── KEYCHAIN ─────────────────────────────────────────────────────────────
    func handleKeychainSet(_ body: [String: Any]) {
        guard let key = body["key"] as? String, let value = body["value"] as? String else { return }
        let data = value.data(using: .utf8)!
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecAttrService: "net.tradepulsepro"
        ]
        SecItemDelete(query as CFDictionary)
        var addQuery = query; addQuery[kSecValueData] = data
        SecItemAdd(addQuery as CFDictionary, nil)
    }

    func handleKeychainGet(_ body: [String: Any]) {
        guard let key = body["key"] as? String else { return }
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecAttrService: "net.tradepulsepro",
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        if status == errSecSuccess, let data = result as? Data, let value = String(data: data, encoding: .utf8) {
            dispatchEvent("tradepulse_keychain_get_\(key)", detail: ["value": value, "found": true])
        } else {
            dispatchEvent("tradepulse_keychain_get_\(key)", detail: ["value": "", "found": false])
        }
    }

    func handleKeychainDelete(_ body: [String: Any]) {
        guard let key = body["key"] as? String else { return }
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecAttrService: "net.tradepulsepro"
        ]
        SecItemDelete(query as CFDictionary)
    }

    // ─── OPEN URL ─────────────────────────────────────────────────────────────
    func handleOpenURL(_ body: [String: Any]) {
        guard let urlStr = body["url"] as? String, let url = URL(string: urlStr) else { return }
        DispatchQueue.main.async { UIApplication.shared.open(url) }
    }
}

// ─── Sign in with Apple delegates ─────────────────────────────────────────────
extension NativeBridge: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return viewController?.view.window ?? UIWindow()
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let cred = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userId    = cred.user
            let email     = cred.email ?? ""
            let firstName = cred.fullName?.givenName ?? ""
            let lastName  = cred.fullName?.familyName ?? ""
            dispatchEvent("tradepulse_apple_signin", detail: [
                "success": true,
                "userId": userId,
                "email": email,
                "firstName": firstName,
                "lastName": lastName
            ])
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        dispatchEvent("tradepulse_apple_signin", detail: ["success": false, "error": error.localizedDescription])
    }
}

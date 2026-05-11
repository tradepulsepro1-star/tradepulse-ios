import UIKit
import WebKit
import AuthenticationServices
import CryptoKit

/// Google Sign-In via ASWebAuthenticationSession (no SDK dependency needed)
/// Uses Google OAuth2 web flow — works without the Google Sign-In SDK
class GoogleSignInManager: NSObject {
    
    static let shared = GoogleSignInManager()
    
    // TradePulse Google OAuth Client ID (iOS)
    // Set this to your actual Google OAuth2 iOS client ID from Firebase/Google Cloud Console
    private let clientID = "YOUR_GOOGLE_CLIENT_ID.apps.googleusercontent.com"
    private let redirectScheme = "net.tradepulsepro"
    private let redirectURI = "net.tradepulsepro:/oauth2redirect"
    
    private var webView: WKWebView?
    private var callbackName: String?
    private var authSession: ASWebAuthenticationSession?
    private var currentViewController: UIViewController?
    
    func signIn(webView: WKWebView, callbackName: String, viewController: UIViewController) {
        self.webView = webView
        self.callbackName = callbackName
        self.currentViewController = viewController
        
        let state = UUID().uuidString
        let nonce = UUID().uuidString
        
        var components = URLComponents(string: "https://accounts.google.com/o/oauth2/v2/auth")!
        components.queryItems = [
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: "openid email profile"),
            URLQueryItem(name: "state", value: state),
            URLQueryItem(name: "nonce", value: nonce),
            URLQueryItem(name: "prompt", value: "select_account")
        ]
        
        guard let authURL = components.url else {
            sendError("Failed to build auth URL")
            return
        }
        
        let session = ASWebAuthenticationSession(url: authURL, callbackURLScheme: redirectScheme) { [weak self] callbackURL, error in
            guard let self = self else { return }
            
            if let error = error {
                if (error as NSError).code == ASWebAuthenticationSessionError.canceledLogin.rawValue {
                    self.sendError("User cancelled Google Sign-In")
                } else {
                    self.sendError(error.localizedDescription)
                }
                return
            }
            
            guard let callbackURL = callbackURL,
                  let components = URLComponents(url: callbackURL, resolvingAgainstBaseURL: false),
                  let code = components.queryItems?.first(where: { $0.name == "code" })?.value else {
                self.sendError("No authorization code received")
                return
            }
            
            // Return the auth code to the web app — the web app exchanges it with the backend
            DispatchQueue.main.async {
                let js = """
                \(self.callbackName ?? "console.log")({
                    success: true,
                    provider: 'google',
                    code: '\(code)',
                    state: '\(state)'
                })
                """
                self.webView?.evaluateJavaScript(js, completionHandler: nil)
            }
        }
        
        session.presentationContextProvider = self
        session.prefersEphemeralWebBrowserSession = false
        self.authSession = session
        session.start()
    }
    
    private func sendError(_ message: String) {
        DispatchQueue.main.async {
            let js = "\(self.callbackName ?? "console.log")({ success: false, provider: 'google', error: '\(message)' })"
            self.webView?.evaluateJavaScript(js, completionHandler: nil)
        }
    }
}

extension GoogleSignInManager: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return currentViewController?.view.window ?? UIWindow()
    }
}

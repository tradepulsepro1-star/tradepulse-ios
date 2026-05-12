import AuthenticationServices
import WebKit

class SignInWithAppleManager: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {

    static let shared = SignInWithAppleManager()
    var webView: WKWebView?
    var callbackName: String?
    var viewController: UIViewController?

    func signIn(webView: WKWebView, callbackName: String, viewController: UIViewController) {
        self.webView = webView
        self.callbackName = callbackName
        self.viewController = viewController

        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return viewController?.view.window ?? UIWindow()
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        let userID = credential.user
        let email = credential.email ?? ""
        let firstName = credential.fullName?.givenName ?? ""
        let lastName = credential.fullName?.familyName ?? ""
        let identityToken = String(data: credential.identityToken ?? Data(), encoding: .utf8) ?? ""

        let js = """
        \(callbackName ?? "console.log")({
            success: true,
            userID: '\(userID)',
            email: '\(email)',
            firstName: '\(firstName)',
            lastName: '\(lastName)',
            identityToken: '\(identityToken)'
        })
        """
        webView?.evaluateJavaScript(js, completionHandler: nil)
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        let js = "\(callbackName ?? "console.log")({ success: false, error: '\(error.localizedDescription)' })"
        webView?.evaluateJavaScript(js, completionHandler: nil)
    }
}

//
//  UIApplication+Extensions.swift
//  TradePulse
//
//  Safe window access for iOS 13+ through iOS 26+
//

import UIKit

extension UIApplication {
    @objc public var currentKeyWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            // Try foreground active scene first, fall back to any scene
            let activeWindow = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .filter { $0.activationState == .foregroundActive }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }
            if activeWindow != nil { return activeWindow }
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        }
    }

    @objc public var currentStatusBarFrame: CGRect {
        return currentKeyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
    }

    @objc public var isInterfaceOrientationPortrait: Bool {
        let orientation = currentKeyWindow?.windowScene?.interfaceOrientation
        return orientation?.isPortrait ?? true
    }
}

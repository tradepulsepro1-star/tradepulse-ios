//  WindowsController.swift - Patched: GoNativeCore removed
import Foundation
import UIKit

@objc class WindowsController: NSObject {
    @objc class public func windowCountChanged() {
        let maxWindows = 20
        guard LEANWebViewController.currentWindows > maxWindows else {
            return
        }
        if let rootViewController = UIApplication.shared.windows.first?.rootViewController as? LEANRootViewController,
           let navigationController = rootViewController.contentViewController as? UINavigationController {
            var viewControllers = navigationController.viewControllers
            let removeTillIndex = LEANWebViewController.currentWindows - maxWindows
            viewControllers.removeSubrange(1...removeTillIndex)
            navigationController.viewControllers = viewControllers
        }
    }
}

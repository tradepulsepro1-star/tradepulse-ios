//
//  WindowsController.swift
//  GonativeIO
//
//  Created by Hunaid Hassan on 14.06.21.
//  Copyright © 2021 GoNative.io LLC. All rights reserved.
//

import Foundation

@objc class WindowsController: NSObject {
    @objc class public func windowCountChanged() {
        let appConfig = GoNativeAppConfig.shared()!
        guard LEANWebViewController.currentWindows > appConfig.maxWindows else {
            return
        }
        
        let keyWindow: UIWindow?
        if #available(iOS 13.0, *) {
            keyWindow = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first
        } else {
            keyWindow = UIApplication.shared.keyWindow
        }
        
        if let rootViewController = keyWindow?.rootViewController as? LEANRootViewController,
           let navigationController = rootViewController.contentViewController as? UINavigationController {
            var viewControllers = navigationController.viewControllers
            let removeTillIndex = LEANWebViewController.currentWindows - appConfig.maxWindows
            viewControllers.removeSubrange(1...removeTillIndex)
            navigationController.viewControllers = viewControllers
        }
    }
}

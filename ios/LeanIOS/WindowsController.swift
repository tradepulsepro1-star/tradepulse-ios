//
//  WindowsController.swift
//  GonativeIO
//
//  Created by Hunaid Hassan on 14.06.21.
//  Copyright © 2021 GoNative.io LLC. All rights reserved.
//
//  NOTE: GoNativeCore package removed — window count management stubbed.

import Foundation
import UIKit

@objc class WindowsController: NSObject {
    @objc class public func windowCountChanged() {
        // No-op: GoNativeCore not available in this build.
        // Window limit enforcement is handled by the underlying webview stack.
    }
}

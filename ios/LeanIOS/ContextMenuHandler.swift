//
//  ContextMenuHandler.swift
//  Median
//
//  Created by Kevz on 4/18/24.
//  Copyright © 2024 GoNative.io LLC. All rights reserved.
//
//  NOTE: GoNativeCore package removed — stubbed to return nil context menu.

import Foundation
import UIKit

@objc public class ContextMenuHandler: NSObject {
    @objc public static func createConfigurationWith(url: URL, shareAction: @escaping () -> Void) -> UIContextMenuConfiguration? {
        // Context menu disabled — GoNativeCore not available in this build.
        return nil
    }
}

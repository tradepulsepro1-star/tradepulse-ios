//
//  ContextMenuHandler.swift
//  TradePulse
//

import Foundation
import UIKit

@objc public class ContextMenuHandler: NSObject {
    @objc(createConfigurationWithUrl:shareAction:)
    public static func createConfiguration(url: URL, shareAction: @escaping () -> Void) -> UIContextMenuConfiguration? {
        // Context menus disabled - no GoNativeCore available
        return nil
    }
}

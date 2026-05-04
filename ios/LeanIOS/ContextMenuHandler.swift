//  ContextMenuHandler.swift - Patched: GoNativeCore removed
import Foundation
import UIKit

@objc public class ContextMenuHandler: NSObject {
    @objc public static func createConfigurationWith(url: URL, shareAction: @escaping () -> Void) -> UIContextMenuConfiguration? {
        // Context menu disabled (GoNativeCore removed)
        return nil
    }
}

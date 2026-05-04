//  LEANIcons.swift - Patched: MedianIcons removed
import Foundation
import UIKit

@objc class LEANIcons: NSObject {
    @objc public static let sharedIcons = LEANIcons()

    @objc public class func imageForIconIdentifier(_ name: String, size: CGFloat, color: UIColor) -> UIImage? {
        // MedianIcons framework removed - return nil (no custom icons)
        return nil
    }
}

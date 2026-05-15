//
//  LEANIcons.swift
//  GonativeIO
//
//  Stub — MedianIcons framework not available. Returns nil for all icon lookups.
//

import Foundation
import UIKit

@objc class LEANIcons: NSObject {
    @objc public static let sharedIcons = LEANIcons()

    @objc public class func imageForIconIdentifier(_ name: String, size: CGFloat, color: UIColor) -> UIImage? {
        return nil
    }
}

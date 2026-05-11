//
//  LEANIcons.swift
//  GonativeIO
//
//  Created by Anuj Sevak on 2021-04-21.
//  Copyright © 2021 GoNative.io LLC. All rights reserved.
//
//  NOTE: MedianIcons package removed — stubbed to use SF Symbols fallback.

import Foundation
import UIKit

@objc class LEANIcons: NSObject {
    @objc public static let sharedIcons = LEANIcons()

    /// Returns an SF Symbol matching the icon name when available,
    /// otherwise falls back to a blank image of the requested size.
    @objc public class func imageForIconIdentifier(_ name: String, size: CGFloat, color: UIColor) -> UIImage? {
        // Try SF Symbols first (covers most common icon names)
        if let sfImage = UIImage(systemName: name)?.withTintColor(color, renderingMode: .alwaysOriginal) {
            let config = UIImage.SymbolConfiguration(pointSize: size)
            return sfImage.applyingSymbolConfiguration(config)
        }
        // Graceful fallback: transparent image at requested size
        UIGraphicsBeginImageContextWithOptions(CGSize(width: size, height: size), false, 0)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

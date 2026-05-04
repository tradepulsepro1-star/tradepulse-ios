//
//  LEANIcons.swift
//  TradePulse
//

import Foundation
import UIKit

@objc public class LEANIcons: NSObject {
    @objc public static let sharedIcons = LEANIcons()
    
    @objc public class func imageForIconIdentifier(_ name: String, size: CGFloat, color: UIColor) -> UIImage? {
        // Fallback to SF Symbols; return nil if not found
        let config = UIImage.SymbolConfiguration(pointSize: size)
        if let img = UIImage(systemName: name, withConfiguration: config) {
            return img.withTintColor(color, renderingMode: .alwaysOriginal)
        }
        return UIImage(systemName: "circle", withConfiguration: config)?
            .withTintColor(color, renderingMode: .alwaysOriginal)
    }
}

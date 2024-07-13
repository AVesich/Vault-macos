//
//  ColorExtension.swift
//  Vault
//
//  Created by Austin Vesich on 6/9/24.
//

import SwiftUI
import AppKit

extension Color {
    // From: https://blog.eidinger.info/from-hex-to-color-and-back-in-swiftui
    func hexCode() -> String? {
        let nsColor = NSColor(self)
        guard let components = nsColor.cgColor.components, components.count >= 3 else {
            return nil
        }
        
        let redComponent = Float(components[0])
        let greenComponent = Float(components[1])
        let blueComponent = Float(components[2])
        
        if components.count >= 4, Float(components[3]) != 1.0 {
            let alphaComponent = Float(components[3])
            return String(format: "%02lX%02lX%02lX%02lX",
                          lroundf(redComponent * 255),
                          lroundf(greenComponent * 255),
                          lroundf(blueComponent * 255),
                          lroundf(alphaComponent * 255))
        } else {
            return String(format: "%02lX%02lX%02lX",
                          lroundf(redComponent * 255),
                          lroundf(greenComponent * 255),
                          lroundf(blueComponent * 255))
        }
    }
}

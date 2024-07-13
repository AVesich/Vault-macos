//
//  ColorExtension.swift
//  Vault
//
//  Created by Austin Vesich on 6/9/24.
//

import SwiftUI
import AppKit

extension Color {
    func isBright() -> Bool {
        let nsColor = NSColor(self)
        guard let components = nsColor.cgColor.components, components.count >= 3 else {
            return false
        }
        
        let redComponent = Float(components[0])
        let greenComponent = Float(components[1])
        let blueComponent = Float(components[2])
        
        let luminance = (0.299 * redComponent) +
                        (0.587 * greenComponent) +
                        (0.114 * blueComponent)
        
        return luminance > 0.5
    }
}

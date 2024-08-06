//
//  ColorExtension.swift
//  Vault
//
//  Created by Austin Vesich on 6/9/24.
//

import SwiftUI
import AppKit

extension Color {
    private func getLuminance() -> CGFloat {
        let nsColor = NSColor(self)
        guard let components = nsColor.cgColor.components, components.count >= 3 else {
            return 0.0
        }
        
        let redComponent = Float(components[0])
        let greenComponent = Float(components[1])
        let blueComponent = Float(components[2])
        
        let luminance = (0.299 * redComponent) + (0.587 * greenComponent) + (0.114 * blueComponent)
        
        return CGFloat(luminance)
    }
    
    func isBright() -> Bool {
        return getLuminance() > 0.5
    }
    
    func shouldGlow() -> Bool {
        let notClear = NSColor(self).alphaComponent > 0.1
        let glows = !(self == .clear) && !(self == .black)
        let notDark = getLuminance() > 0.15
        return notClear && notDark && glows
    }
}

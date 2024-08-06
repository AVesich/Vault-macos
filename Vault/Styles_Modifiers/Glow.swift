//
//  Glow.swift
//  Vault
//
//  Created by Austin Vesich on 8/5/24.
//

import SwiftUI

struct Glow: ViewModifier {
    
    public var color: Color = .clear
    @AppStorage("backgroundGlowAmount") private var backgroundGlowAmount: Double = 0.0
    
    func body(content: Content) -> some View {
        ZStack {
            if color.shouldGlow() {
                Rectangle()
                    .fill(color)
                    .mask(content.blur(radius: backgroundGlowAmount))
            }
            content
        }
    }
}

extension View {
    func glow(color: Color) -> some View {
        modifier(Glow(color: color))
    }
}

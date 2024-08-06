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
    @State private var contentSize: CGSize = .zero
    
    func body(content: Content) -> some View {
        ZStack {
            if color.shouldGlow() {
                Rectangle()
                    .fill(color)
                    .mask(content.blur(radius: backgroundGlowAmount))
            }
            content
                .getSize {
                    contentSize = $0
                }
        }
        .frame(width: contentSize.width+backgroundGlowAmount+25.0,
               height: contentSize.height+backgroundGlowAmount+25.0)
    }
}

extension View {
    func glow(color: Color) -> some View {
        modifier(Glow(color: color))
    }
}

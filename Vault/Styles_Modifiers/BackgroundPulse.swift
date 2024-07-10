//
//  BackgroundGradient.swift
//  Vault
//
//  Created by Austin Vesich on 7/7/24.
//

import SwiftUI

struct BackgroundPulse: ViewModifier {
    public var enabled: Bool
    public var color: Color
    @State private var shadowColor: Color = .clear
    @State private var shadowRadius: CGFloat = 0.0
        
    func body(content: Content) -> some View {
        ZStack() {
            RoundedRectangle(cornerRadius: 16.0)
                .size(CGSize(width: 600.0, height: 300.0))
                .stroke(shadowColor, lineWidth: shadowRadius)
                .blur(radius: shadowRadius)
//                .shadow(color: shadowColor, radius: shadowRadius)
                .onChange(of: enabled) {
                    if enabled {
                        shadowColor = color
                        withAnimation(.easeOut(duration: 0.5)) {
                            shadowRadius = 96.0
                            shadowColor = color.opacity(0.0)
                        }
                    } else {
                        shadowRadius = 0.0
                        shadowColor = .clear
                    }
                }
            content
        }
    }
}

extension View {
    @inlinable
    public func reverseMask(mask: some View) -> some View {
        self.mask {
            ZStack {
                Rectangle()
                    .overlay {
                        mask
                            .blendMode(.destinationOut)
                    }
            }
        }
    }
    
    func backgroundPulse(enabled isEnabled: Bool, color: Color) -> some View {
        modifier(BackgroundPulse(enabled: isEnabled, color: color))
    }
}

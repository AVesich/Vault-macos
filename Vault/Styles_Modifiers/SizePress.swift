//
//  BackgroundGradient.swift
//  Vault
//
//  Created by Austin Vesich on 7/7/24.
//

import SwiftUI

struct SizePress: ViewModifier {
    public var press: Bool
    @State private var scaleEffect: CGFloat = 1.0
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .onChange(of: press) {
                    if press {
                        withAnimation(.spring(response: 0.15, dampingFraction: 0.65, blendDuration: 0.15)) {
                            scaleEffect = 0.98
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            withAnimation(.spring(response: 0.15, dampingFraction: 0.65, blendDuration: 0.15)) {
                                scaleEffect = 1.0
                            }
                        }
                    }
                }
                .scaleEffect(scaleEffect)
        }
    }
}

extension View {
    func sizePress(press: Bool) -> some View {
        modifier(SizePress(press: press))
    }
}

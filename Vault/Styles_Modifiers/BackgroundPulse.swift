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
    
    func body(content: Content) -> some View {
        ZStack {
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

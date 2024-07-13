//
//  FontExtension.swift
//  Vault
//
//  Created by Austin Vesich on 5/19/24.
//

import SwiftUI

extension Font {
    static func manrope(_ size: CGFloat, weight: Weight = .regular) -> Font {
        switch weight {
        case .bold:
            return Font.custom("Manrope-Bold", size: size)
        case .medium, .semibold:
            return Font.custom("Manrope-Medium", size: size)
        case .regular:
            return Font.custom("Manrope-Regular", size: size)
        default:
            return Font.custom("Manrope-Regular", size: size)
        }
    }
}

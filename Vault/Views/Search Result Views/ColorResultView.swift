//
//  ColorResultView.swift
//  Vault
//
//  Created by Austin Vesich on 6/8/24.
//

import SwiftUI

struct ColorResultView: View {
    
    var colors: [Color]
    
    var body: some View {
        HStack(spacing: 16.0) {
            HStack(spacing: 16.0) {
                ForEach(colors, id: \.self) { color in
                    ZStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 8.0)
                            .fill(color)
                            .frame(width: .infinity, height: 36.0)
                        Text("#\(color.hexCode() ?? "")")
                            .font(.manrope(12.0, weight: .bold))
                            .foregroundStyle(color.isBright() ? Color.black : .white)
                    }
                }
            }
            .onTapGesture {
                // TODO: - Add copy colors on click
            }
        }
    }
}

#Preview {
    ColorResultView(colors: [.red, .pink, .orange, .yellow, .green])
}

//
//  ColorResultView.swift
//  Vault
//
//  Created by Austin Vesich on 6/8/24.
//

import SwiftUI

struct ColorResultView: View {
    @State private var hovering: Bool = false
    var searchResult: SearchResult
    
    var body: some View {
        HStack(spacing: 16.0) {
            HStack(spacing: 16.0) {
                ForEach(searchResult.colors!, id: \.self) { color in
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
            .onHover { hover in
                hovering = hover
            }
            .onTapGesture {
                // TODO: - Add copy colors on click
            }
            
            if hovering {
                Button {
                    // TODO: - Add copy colors on click
                } label: {
                    Image(systemName: "doc.on.doc")
                }
                .buttonStyle(.borderless)
            }
        }
        .animation(.spring(response: 0.25, dampingFraction: 0.55, blendDuration: 1.0))
    }
}

#Preview {
    ColorResultView(searchResult: SearchResult(colors: [.red, .pink, .orange, .yellow, .green]))
}

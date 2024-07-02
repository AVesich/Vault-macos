//
//  FontResultVie.swift
//  Vault
//
//  Created by Austin Vesich on 6/9/24.
//

import SwiftUI

struct FontResultView: View {
    
    @State private var hovering: Bool = false
    var font: NSFont
    
    var body: some View {
        HStack(alignment: .center, spacing: 16.0) {
            VStack(alignment: .leading, spacing: 4.0) {
                Text(font.fontName)
                    .lineLimit(1)
                    .font(.manrope(12.0, weight: .bold))
                    .padding(.leading, 16.0)
                Text("The quick brown fox runs over the lazy dog.")
                    .font(.custom(font.fontName, size: 24.0))
                    .frame(width: .infinity)
            }

            Spacer()
            
            if hovering {
                Button {
                    // TODO: - Add copy name on click
                } label: {
                    Image(systemName: "document.on.document.fill")
                        .frame(width: 24.0, height: 24.0)
                }
                .buttonStyle(.borderless)
            }
        }
        .animation(.spring(response: 0.25, dampingFraction: 0.55, blendDuration: 1.0), value: hovering)
        .padding(.vertical, 8.0)
        .onHover { hover in
            hovering = hover
        }
        .onTapGesture {
            // TODO: - Add copy colors on click
        }
    }
}

#Preview {
    FontResultView(font: NSFont(name: "Helvetica", size: 24.0)!)
}

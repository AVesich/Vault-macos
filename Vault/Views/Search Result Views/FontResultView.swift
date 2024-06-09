//
//  FontResultVie.swift
//  Vault
//
//  Created by Austin Vesich on 6/9/24.
//

import SwiftUI

struct FontResultView: View {
    
    @State private var hovering: Bool = false
    var searchResult: SearchResult
    
    var body: some View {
        HStack(alignment: .center, spacing: 16.0) {
            VStack(alignment: .leading) {
                Text("Font name")
                    .font(.manrope(12.0, weight: .bold))
                    .padding(.leading, 16.0)
                Text("The quick brown fox runs over the lazy dog.")
                    .font(.manrope(24.0))
                    .frame(width: .infinity)
            }

            Spacer()
            
            if hovering {
                Button {
                    // TODO: - Add copy colors on click
                } label: {
                    Image(systemName: "arrow.down.to.line")
                        .frame(width: 24.0, height: 24.0)
                }
                .buttonStyle(.borderless)
            }
        }
        .animation(.spring(response: 0.25, dampingFraction: 0.55, blendDuration: 1.0))
        .frame(height: 48.0)
        .onHover { hover in
            hovering = hover
        }
        .onTapGesture {
            // TODO: - Add copy colors on click
        }
    }
}

#Preview {
    FontResultView(searchResult: SearchResult(font: .manrope(24.0)))
}

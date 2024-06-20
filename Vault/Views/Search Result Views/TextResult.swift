//
//  TextResult.swift
//  Vault
//
//  Created by Austin Vesich on 6/18/24.
//

import SwiftUI

struct TextResult: View {
    
    @State private var isHovering: Bool = false
    var searchResult: SearchResult

    var body: some View {
        HStack {
            Text(searchResult.text!)
                .font(.manrope(18.0))
                .padding(.leading, 8.0)
                .padding(.vertical, 2.0)
            Spacer()
        }
        .background {
            RoundedRectangle(cornerRadius: 4.0)
                .fill(isHovering ? .white.opacity(0.1) : .clear)
                .animation(.easeOut(duration: 0.1), value: isHovering)
        }
        .onHover { hovering in
            isHovering = hovering
        }
    }
}

#Preview {
    TextResult(searchResult: SearchResult(text: "/GitHub"))
}

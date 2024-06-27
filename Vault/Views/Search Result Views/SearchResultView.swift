//
//  SearchResultView.swift
//  Vault
//
//  Created by Austin Vesich on 6/23/24.
//

import SwiftUI

struct SearchResultView: View {
    
    @State private var isHovering: Bool = false
    public var searchResult: any SearchResult
    
    var body: some View {
        AnyView(searchResult.view)
            .padding(.horizontal, 8.0)
            .background {
                RoundedRectangle(cornerRadius: 8.0)
                    .fill(isHovering && !(searchResult is ImagesResult) ? .white.opacity(0.1) : .clear)
                    .animation(.easeOut(duration: 0.1), value: isHovering)
            }
            .onHover { hovering in
                isHovering = hovering
            }
            .padding(.horizontal, (searchResult is ImagesResult) ? 0.0 : 8.0)
            .padding(.top, (searchResult is ImagesResult) ? 8.0 : 0.0)
    }
}

#Preview {
    SearchResultView(searchResult: ModeResult(content: .gitHub))
}

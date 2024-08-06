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
    public var canAutocomplete: Bool
    public var isSelected: Bool
    private var backgroundColor: Color {
        if isHovering && !(searchResult is ImagesResult) {
            return .white.opacity(0.2)
        } else if isSelected {
            return .white.opacity(0.1)
        } else {
            return .clear
        }
    }
    
    var body: some View {
        HStack(spacing: 8.0) {
            if (isSelected || isHovering) && !(searchResult is ImagesResult) { //&& canAutocomplete {
                searchResult.activityIcon
                    .imageScale(.small)
            }
            AnyView(searchResult.view)
        }
        .padding(.horizontal, 8.0)
        .background {
            RoundedRectangle(cornerRadius: 8.0)
                .fill(backgroundColor)
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
    SearchResultView(searchResult: ModeResult(content: SearchMode(modeType: .github,
                                                                  systemIconName: "cat.fill",
                                                                  engine: GitHubSearchEngine())),
                     canAutocomplete: true,
                     isSelected: true)
}

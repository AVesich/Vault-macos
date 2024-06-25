//
//  SearchResultView.swift
//  Vault
//
//  Created by Austin Vesich on 6/23/24.
//

import SwiftUI

struct SearchResultView: View {
    
    public var searchResult: SearchResult
    @State private var isHovering: Bool = false
    
    var body: some View {
        searchResultView(for: searchResult)
            .padding(.horizontal, 8.0)
            .background {
                RoundedRectangle(cornerRadius: 8.0)
                    .fill(isHovering && (searchResult.resultStyle != .images) ? .white.opacity(0.1) : .clear)
                    .animation(.easeOut(duration: 0.1), value: isHovering)
            }
            .onHover { hovering in
                isHovering = hovering
            }
            .padding(.horizontal, searchResult.resultStyle == .images ? 0.0 : 8.0)
            .padding(.top, searchResult.resultStyle == .images ? 8.0 : 0.0)
    }
    
    @ViewBuilder private func searchResultView(for searchResult: SearchResult) -> some View {
        switch searchResult.resultStyle {
        case .systemFile:
            FilePathResult(searchResult: searchResult)
        case .colorGroup:
            ColorResult(searchResult: searchResult)
        case .font:
            FontResult(searchResult: searchResult)
        case .images:
            ImagesResult(searchResult: searchResult)
        case .gitHubRepo:
            GitHubResult(searchResult: searchResult)
        case .searchMode:
            SearchModeResult(searchResult: searchResult)
        default:
            Text("text result")
        }
    }
}

#Preview {
    SearchResultView(searchResult: SearchResult(searchMode: .gitHub))
}

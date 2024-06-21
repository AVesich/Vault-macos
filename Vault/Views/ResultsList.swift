//
//  ResultsList.swift
//  Vault
//
//  Created by Austin Vesich on 5/22/24.
//

import SwiftUI

struct ResultsList: View {
    
    @Environment(Search.self) var searchModel
    @State var scrollViewSize: CGSize = .zero
    
    var body: some View {
        if !searchModel.results.isEmpty {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack {
                    ForEach(Array(searchModel.results.enumerated()), id: \.offset) { (index, searchResult) in
                        HStack {
                            searchResultView(for: searchResult)
                                .padding(.bottom, (index == searchModel.results.count-1) ? 8.0 : 0.0)
                        }
                    }
                }
                .getSize {scrollViewSize = $0}
            }
            .frame(height: scrollViewSize.height<=512.0 ? scrollViewSize.height : 512.0)
        }
    }
    
    @ViewBuilder private func searchResultView(for searchResult: SearchResult) -> some View {
        switch searchResult.resultStyle {
        case .systemFile:
            FilePathResult(searchResult: searchResult)
                .padding(.horizontal, 16.0)
        case .colorGroup:
            ColorResult(searchResult: searchResult)
                .padding(.horizontal, 16.0)
        case .font:
            FontResult(searchResult: searchResult)
                .padding(.horizontal, 16.0)
        case .images:
            ImagesResult(searchResult: searchResult)
                .padding(.top, 8.0)
        case .searchMode:
            SearchModeResult(searchResult: searchResult)
                .padding(.horizontal, 16.0)
        default:
            Text("text result")
        }
    }
}

#Preview {
    ResultsList()
        .environment(Search())
}

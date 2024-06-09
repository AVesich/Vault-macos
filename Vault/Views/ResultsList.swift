//
//  ResultsList.swift
//  Vault
//
//  Created by Austin Vesich on 5/22/24.
//

import SwiftUI

struct ResultsList: View {
    
    @Binding var results: [SearchResult]
    
    var body: some View {
        if !results.isEmpty {
            LazyVStack {
                ForEach($results) { searchResult in
                    HStack {
                        searchResultView(for: searchResult.wrappedValue)
                            .listRowSeparator(.hidden)
                    }
                }
            }
        }
    }
    
    @ViewBuilder private func searchResultView(for searchResult: SearchResult) -> some View {
        switch searchResult.resultStyle {
        case .systemFile:
            FilePathResultView(searchResult: searchResult)
        case .colorGroup:
            ColorResultView(searchResult: searchResult)
        case .font:
            FontResultView(searchResult: searchResult)
        default:
            Text("text result")
        }
    }
}

#Preview {
    ResultsList(results: .constant([SearchResult(filePath: URL(string: "url 1")!),
                                    SearchResult(colors: [.red, .pink, .orange, .yellow, .green]),
                                    SearchResult(font: .system(size: 24.0))]))
}

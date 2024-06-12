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
            ScrollView {
                LazyVStack {
                    ForEach($results) { searchResult in
                        HStack {
                            searchResultView(for: searchResult.wrappedValue)
                                .listRowSeparator(.hidden)
                        }
                    }
                }
            }
            .frame(maxHeight: 256.0)
        }
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

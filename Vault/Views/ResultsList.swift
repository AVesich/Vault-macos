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
            List($results) { searchResult in
                searchResultView(for: searchResult.wrappedValue)
                    .listRowSeparator(.hidden)
            }
            .scrollContentBackground(.hidden)
            .deleteDisabled(true)
        }
    }
    
    @ViewBuilder private func searchResultView(for searchResult: SearchResult) -> some View {
        switch searchResult.resultStyle {
        case .systemFile:
            FilePathResultView(searchResult: searchResult)
        default:
            Text("text result")
        }
    }
}

#Preview {
    ResultsList(results: .constant([SearchResult(filePath: URL(string: "url 1")!),
                                    SearchResult(filePath: URL(string: "url 2")!),
                                    SearchResult(filePath: URL(string: "url 3")!)]))
}

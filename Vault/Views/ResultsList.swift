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
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack {
                    ForEach(Array(results.enumerated()), id: \.offset) { (index, searchResult) in
                        searchResultView(for: searchResult)
                            .padding(.top, index == 0 ? 8.0 : 0.0)
                    }
                }
            }
            .frame(maxHeight: 512.0)
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
        default:
            Text("text result")
        }
    }
}

#Preview {
    ResultsList(results: .constant([SearchResult(filePath: URL(string: "url 1")!),
                                    SearchResult(colors: [.red, .pink, .orange, .yellow, .green]),
                                    SearchResult(font: .system(size: 24.0)),
                                    SearchResult(images: [
                                        Image("Test_Cat_1"),
                                        Image("Test_Cat_2"),
                                        Image("Test_Cat_3")
                                    ])]))
}

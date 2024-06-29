//
//  ResultsList.swift
//  Vault
//
//  Created by Austin Vesich on 5/22/24.
//

import SwiftUI
import SwiftData

struct ResultsList: View {
    
    @Environment(GlobalSearch.self) var searchModel
    @State private var scrollViewSize: CGSize = .zero
    
    var body: some View {
        if !searchModel.publishedResults.isEmpty {
            Divider()
                .padding(.horizontal, 16.0)
                .padding(.bottom, 8.0)
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack {
                    ForEach(Array(searchModel.publishedResults.enumerated()), id: \.offset) { (index, searchResult) in
                        HStack(spacing: 8.0) {
                            SearchResultView(searchResult: searchResult)
                        }
                        .onTapGesture {
                            searchModel.autocompleteSearch(fromIndex: index)
                        }
                    }
                }
                .padding(.bottom, 8.0)
                .getSize {scrollViewSize = $0}
            }
            .frame(height: scrollViewSize.height<=512.0 ? scrollViewSize.height : 512.0)
        }
    }
}

#Preview {
    let dummyContainer = try! ModelContainer(for: Search.self)

    ResultsList()
        .environment(GlobalSearch(modelContext: dummyContainer.mainContext))
}

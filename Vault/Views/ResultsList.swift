//
//  ResultsList.swift
//  Vault
//
//  Created by Austin Vesich on 5/22/24.
//

import SwiftUI

struct ResultsList: View {
    
    @Environment(Search.self) var searchModel
    @State private var scrollViewSize: CGSize = .zero
    
    var body: some View {
        if !searchModel.results.isEmpty {
            Divider()
                .padding(.horizontal, 8.0)
                .padding(.bottom, 8.0)
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack {
                    ForEach(Array(searchModel.results.enumerated()), id: \.offset) { (index, searchResult) in
                        HStack {
                            SearchResultView(searchResult: searchResult)
                                .padding(.bottom, (index == searchModel.results.count-1) ? 8.0 : 0.0)
                        }
                    }
                }
                .getSize {scrollViewSize = $0}
            }
            .frame(height: scrollViewSize.height<=512.0 ? scrollViewSize.height : 512.0)
        }
    }
}

#Preview {
    ResultsList()
        .environment(Search())
}

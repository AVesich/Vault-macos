//
//  TextResult.swift
//  Vault
//
//  Created by Austin Vesich on 6/18/24.
//

import SwiftUI

struct SearchModeResult: View {
    
    @Environment(Search.self) var searchModel
    @State private var isHovering: Bool = false
    var searchResult: SearchResult

    var body: some View {
        HStack {
            if let first = searchModel.results.first,
               first == searchResult {
                Image(systemName: "return")
                    .fontWeight(.bold)
                    .imageScale(.small)
                    .offset(y: 1.0)
            }
            Text(searchResult.searchMode!.rawValue)
                .font(.manrope(16.0))
            Spacer()
        }
        .frame(height: 28.0)
        .onTapGesture {
            searchModel.searchMode = searchResult.searchMode!
        }
    }
}

#Preview {
    SearchModeResult(searchResult: SearchResult(searchMode: .gitHub))
        .environment(Search())
}

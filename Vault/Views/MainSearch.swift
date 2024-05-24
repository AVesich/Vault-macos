//
//  ContentView.swift
//  Vault
//
//  Created by Austin Vesich on 5/17/24.
//

import SwiftUI
import SwiftData

struct MainSearch: View {
    @State private var usingAI = false
    @State private var searchModel = SearchModel()

    var body: some View {
        VStack {
            VStack {
                DirectorySearchBar(usingAI: $usingAI)
                Divider()
                SearchBar(usingAI: $usingAI, searchModel: $searchModel)
                Divider()
                ResultsList(results: $searchModel.responses)
            }
            .offset(y: -20.0)
            .padding(.horizontal, 16.0)
        }
        .background(Material.regular)
        .frame(width: 600.0)
    }
}

#Preview {
    MainSearch()
        .modelContainer(for: DirectoryConfig.self, inMemory: true)
}

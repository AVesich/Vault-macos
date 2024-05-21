//
//  ContentView.swift
//  Vault
//
//  Created by Austin Vesich on 5/17/24.
//

import SwiftUI
import SwiftData

struct MainSearch: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var usingAI = false

    var body: some View {
        VStack {
            VStack {
                DirectorySearchBar(usingAI: $usingAI)
                Divider()
                SearchBar(usingAI: $usingAI)
                Divider()
            }
            .offset(y: -20.0)
            .padding(.horizontal, 16.0)
        }
        .background(Material.thin)
        .frame(width: 600.0)
    }
}

#Preview {
    MainSearch()
        .modelContainer(for: Item.self, inMemory: true)
}

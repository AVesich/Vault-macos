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

    var body: some View {
        VStack {
            VStack {
                DirectorySearch()
                
                Divider()
                
                SearchBar()
                
                Divider()
            }
            .offset(y: -20.0)
            .padding(.horizontal, 16.0)
        }
        .frame(width: 780.0)
        .background(Material.thin)
    }
}

#Preview {
    MainSearch()
        .modelContainer(for: Item.self, inMemory: true)
}

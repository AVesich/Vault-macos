//
//  ContentView.swift
//  Vault
//
//  Created by Austin Vesich on 5/17/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State var searchQuery: String = ""

    var body: some View {
        VStack {
            HStack(spacing: 20.0) {
                Image(systemName: "magnifyingglass")
                    .imageScale(.large)
                TextField(text: $searchQuery,
                          prompt: Text("Search for a file...")) {}
                    .font(.system(size: 24.0))
                    .textFieldStyle(.plain)
                Spacer()
            }
            .padding(.horizontal, 20.0)
            .padding(.bottom, 12.0)
            
            Divider()
                .padding(.horizontal, 20.0)
        }
        .offset(y: -10.0)
        .background(Material.thin)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}

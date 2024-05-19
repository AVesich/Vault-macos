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
    @State var currentDirectory: String = ""
    @State var searchQuery: String = ""

    var body: some View {
        VStack {
            VStack {
                TextField(text: $searchQuery,
                          prompt: Text("/Users/")) {}
                    .font(.system(size: 16.0))
                    .textFieldStyle(.plain)
                    .padding(.horizontal, 16.0)
                    .padding(.vertical, 4.0)
                
                Divider()
                    .padding(.horizontal, 16.0)
                
                HStack(spacing: 14.0) {
                    Image(systemName: "magnifyingglass")
                        .imageScale(.large)
                    TextField(text: $searchQuery,
                              prompt: Text("Search for a file...")) {}
                        .font(.system(size: 20.0))
                        .textFieldStyle(.plain)
                    Spacer()
                }
                .padding(.vertical, 8.0)
                .padding(.horizontal, 16.0)
                
                Divider()
                    .padding(.horizontal, 16.0)
            }
            .offset(y: -209.0)
        }
        .frame(width: 780.0)
        .background(Material.thin)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}

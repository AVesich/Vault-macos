//
//  SearchBar.swift
//  Vault
//
//  Created by Austin Vesich on 5/18/24.
//

import SwiftUI

struct SearchBar: View {
    
    @State var searchQuery: String = ""

    var body: some View {
        HStack(spacing: 14.0) {
            Image(systemName: "magnifyingglass")
                .imageScale(.large)
            TextField(text: $searchQuery,
                      prompt: Text("Search for a file...")) {}
                .font(.manrope(20.0))
                .textFieldStyle(.plain)
            Spacer()
        }
        .padding(.vertical, 8.0)
    }
}

#Preview {
    SearchBar()
}

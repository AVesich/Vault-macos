//
//  SearchBar.swift
//  Vault
//
//  Created by Austin Vesich on 5/18/24.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var usingAI: Bool
    @Binding var searchModel: SearchModel
    @State private var searchQuery = ""

    var body: some View {
        HStack(spacing: 14.0) {
            Image(systemName: "magnifyingglass")
                .imageScale(.large)
            TextField(text: $searchQuery,
                      prompt: Text("Search...")) {}
                .font(.manrope(18.0))
                .textFieldStyle(.plain)
                .onSubmit {
                    Task {
                        await searchModel.search(withQuery: searchQuery)
                        print(searchModel.responses[0].text)
                    }
                }
            Spacer()
            Button {
                usingAI.toggle()
            } label: {
                Image(systemName: "sparkles")
                    .imageScale(.large)
                Text("⌘ + A")
            }
            .buttonStyle(.borderless)
            .font(.manrope(10.0, weight: .bold))
            .keyboardShortcut("a", modifiers: [.command])
            .scaleEffect(usingAI ? 1.2 : 1.0)
            .tint(usingAI ? .pink : nil)
            .animation(.spring(Spring(response: 0.2, dampingRatio: 0.4)), value: usingAI)
        }
        .padding(.vertical, 6.0)
    }
}

#Preview {
    SearchBar(usingAI: .constant(false), searchModel: .constant(SearchModel()))
}

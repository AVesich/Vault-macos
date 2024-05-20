//
//  SearchBar.swift
//  Vault
//
//  Created by Austin Vesich on 5/18/24.
//

import SwiftUI

struct SearchBar: View {
    
    @State var searchQuery: String = ""
    @State var aiEnabled: Bool = false

    var body: some View {
        HStack(spacing: 14.0) {
            Image(systemName: "magnifyingglass")
                .imageScale(.large)
            TextField(text: $searchQuery,
                      prompt: Text("Search...")) {}
                .font(.manrope(18.0))
                .textFieldStyle(.plain)
            Spacer()
            Button {
                aiEnabled.toggle()
            } label: {
                Image(systemName: "sparkles")
                    .imageScale(.large)
                Text("⌘ + A")
            }
            .buttonStyle(.borderless)
            .font(.manrope(10.0, weight: .bold))
            .keyboardShortcut("a", modifiers: [.command])
            .scaleEffect(aiEnabled ? 1.2 : 1.0)
            .tint(aiEnabled ? .purple : nil)
            .animation(.spring(Spring(response: 0.2, dampingRatio: 0.4)), value: aiEnabled)
        }
        .padding(.vertical, 6.0)
    }
}

#Preview {
    SearchBar()
}

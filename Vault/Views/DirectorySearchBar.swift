//
//  DirectorySearch.swift
//  Vault
//
//  Created by Austin Vesich on 5/18/24.
//

import SwiftUI

struct DirectorySearchBar: View {
    
    @Binding var usingAI: Bool
    @State private var directorySearch = DirectorySearch()
    
    var body: some View {
        HStack(spacing: 14.0) {
            Image(systemName: "folder.fill")
                .imageScale(.small)
                .opacity(0.4)
            
            TextField(text: $directorySearch.currentPrompt,
                      prompt: Text("/Users/")) {}
                .textFieldStyle(.plain)
            
            HStack(spacing: 16.0) {
                Text(directorySearch.suggestedDirectory)
                    .foregroundStyle(.white)
                
                if (!directorySearch.suggestedDirectory.isEmpty) {
                    Button() {
                        directorySearch.autofillCurrentSuggestion()
                    } label: {
                        Text("Enter")
                        Image(systemName: "return")
                            .imageScale(.medium)
                    }
                    .buttonStyle(.borderless)
                    .font(.manrope(10.0, weight: .bold))
                    .keyboardShortcut(.return, modifiers: [])
                }
            }
            .opacity(0.4)
        }
        .font(.manrope(14.0))
        .padding(.vertical, 4.0)
    }
}

#Preview {
    DirectorySearchBar(usingAI: .constant(false))
}

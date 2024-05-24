//
//  DirectorySearch.swift
//  Vault
//
//  Created by Austin Vesich on 5/18/24.
//

import SwiftUI

struct DirectorySearchBar: View {
    
    @Binding var usingAI: Bool
    @State private var directoryConfigIndex = -1
    @State private var directorySearch = DirectorySearch()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4.0) {
            HStack (spacing: 14.0) {
                Image(systemName: "folder.fill")
                    .imageScale(.small)
                    .opacity(0.4)
                
                TextField(text: $directorySearch.currentPrompt,
                          prompt: Text("/Users/")) {}
                    .textFieldStyle(.plain)
                
                DirectoryProfileSelector(selectedIndex: $directoryConfigIndex)
            }
            
            if (!directorySearch.suggestedDirectory.isEmpty) {
                HStack(spacing: 14.0) {
                    Button() {
                        directorySearch.autofillCurrentSuggestion()
                    } label: {
                        Image(systemName: "return")
                            .imageScale(.medium)
                    }
                    .buttonStyle(.borderless)
                    .font(.manrope(10.0, weight: .bold))
                    .keyboardShortcut(.return, modifiers: [])

                    Text(directorySearch.suggestedDirectory)
                        .foregroundStyle(.white)
                }
            }
        }
        .font(.manrope(14.0))
        .padding(.vertical, 4.0)
    }
}

#Preview {
    DirectorySearchBar(usingAI: .constant(false))
}

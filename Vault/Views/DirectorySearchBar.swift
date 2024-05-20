//
//  DirectorySearch.swift
//  Vault
//
//  Created by Austin Vesich on 5/18/24.
//

import SwiftUI

struct DirectorySearchBar: View {
    
    @State var currentDirectory: String = FileManager.default.homeDirectoryForCurrentUser.relativePath
    @State var currentSuggestion: String = ""
    let directorySearch = DirectorySearch()
    
    var body: some View {
        HStack(spacing: 14.0) {
            Image(systemName: "folder.fill")
                .imageScale(.small)
                .opacity(0.4)
            
            TextField(text: $currentDirectory,
                      prompt: Text("/Users/")) {}
                .textFieldStyle(.plain)
                .onChange(of: currentDirectory) {
                    currentSuggestion = directorySearch.getSuggestedDirectory(forDirectorySearch: currentDirectory)
                }
            
            HStack(spacing: 16.0) {
                Text(currentSuggestion)
                
                if (!currentSuggestion.isEmpty) {
                    Button() {
                        autofillCurrentSuggestion()
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
    
    func autofillCurrentSuggestion() {
        let lastSlashIndex = currentDirectory.lastIndex(of: "/") ?? currentDirectory.startIndex
        currentDirectory = currentDirectory[...lastSlashIndex] + currentSuggestion
    }
}

#Preview {
    DirectorySearchBar()
}

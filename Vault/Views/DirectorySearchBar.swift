//
//  DirectorySearch.swift
//  Vault
//
//  Created by Austin Vesich on 5/18/24.
//

import SwiftUI

struct DirectorySearchBar: View {
    
    @State var currentDirectory: String = FileManager.default.homeDirectoryForCurrentUser.relativePath
    let directorySearch = DirectorySearch()
    
    var body: some View {
        HStack(spacing: 2.0) {
            Text("Working Directory: ")
                .font(.manrope(14.0))
            
            TextField(text: $currentDirectory,
                      prompt: Text("/Users/")) {}
                .font(.manrope(14.0))
                .textFieldStyle(.plain)
                .onChange(of: currentDirectory) {
                    directorySearch.getSuggestedDirectory(forDirectorySearch: currentDirectory)
                }
        }
        .padding(.vertical, 4.0)
    }
}

#Preview {
    DirectorySearchBar()
}

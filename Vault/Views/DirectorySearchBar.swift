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
        TextField(text: $currentDirectory,
                  prompt: Text("/Users/")) {}
            .font(.manrope(14.0))
            .textFieldStyle(.plain)
            .padding(.vertical, 4.0)
            .onChange(of: currentDirectory) {
                directorySearch.getDirectoryPaths(fromSearch: currentDirectory)
            }
    }
}

#Preview {
    DirectorySearchBar()
}

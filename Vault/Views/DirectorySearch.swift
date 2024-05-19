//
//  DirectorySearch.swift
//  Vault
//
//  Created by Austin Vesich on 5/18/24.
//

import SwiftUI

struct DirectorySearch: View {
    
    @State var currentDirectory: String = ""
    
    var body: some View {
        TextField(text: $currentDirectory,
                  prompt: Text("/Users/")) {}
            .font(.system(size: 16.0))
            .textFieldStyle(.plain)
            .padding(.vertical, 4.0)
    }
}

#Preview {
    DirectorySearch()
}

//
//  DirectorySearch.swift
//  Vault
//
//  Created by Austin Vesich on 5/18/24.
//

import SwiftUI

struct DirectorySearchBar: View {
    
    @Binding var usingAI: Bool
    @Binding var searchQuery: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4.0) {
            HStack (spacing: 14.0) {
                Image(systemName: "folder.fill")
                    .imageScale(.small)
                    .opacity(0.4)
                
                TextField(text: $searchQuery,
                          prompt: Text("/Users/")) {}
                    .textFieldStyle(.plain)
            }
        }
        .font(.manrope(14.0))
        .padding(.vertical, 4.0)
    }
}

#Preview {
    DirectorySearchBar(usingAI: .constant(false), searchQuery: .constant(""))
}

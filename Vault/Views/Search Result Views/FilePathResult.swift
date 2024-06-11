//
//  FilePathResultView.swift
//  Vault
//
//  Created by Austin Vesich on 6/2/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct FilePathResult: View {
    
    var searchResult: SearchResult
    
    var body: some View {
        HStack(spacing: 16.0) {
            searchResult.filePath!.fileImage
                .resizable()
                .aspectRatio(1.0, contentMode: .fit)
                .frame(width: 20.0, height: 20.0)
            Text(searchResult.filePath!.lastPathComponent)
                .font(.manrope(14.0))
            Spacer()
        }
        .asDraggable(url: searchResult.filePath!)
    }
}

#Preview {
    FilePathResult(searchResult: SearchResult(filePath: URL(string: "/Users/austin/Documents/Vault-macos/Vault/Vault.xcodeproj")!))
}

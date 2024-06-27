//
//  FilePathResultView.swift
//  Vault
//
//  Created by Austin Vesich on 6/2/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct FilePathResultView: View {
    
    var filePath: URL
    
    var body: some View {
        HStack(spacing: 16.0) {
            filePath.fileImage
                .resizable()
                .aspectRatio(1.0, contentMode: .fit)
                .frame(width: 20.0, height: 20.0)
            Text(filePath.lastPathComponent)
                .font(.manrope(14.0))
            Spacer()
        }
        .padding(.vertical, 4.0)
        .asDraggable(url: filePath)
    }
}

#Preview {
    FilePathResultView(filePath: URL(string: "/Users/austin/Documents/Vault-macos/Vault/Vault.xcodeproj")!)
}

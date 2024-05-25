//
//  DirectoryRecommendationView.swift
//  Vault
//
//  Created by Austin Vesich on 5/25/24.
//

import SwiftUI

struct DirectoryRecommendationView: View {
    
    @Binding var queryText: String
    @State private var directorySearch = DirectorySearch()
    
    var body: some View {
        HStack(spacing: 14.0) {
            Button() {
                queryText = directorySearch.autofilledCurrentQuery()
            } label: {
                Image(systemName: "return")
                    .imageScale(.medium)
            }
            .buttonStyle(.borderless)
            .font(.manrope(10.0, weight: .bold))
            .keyboardShortcut(.return, modifiers: [])
            
            Text(directorySearch.suggestedDirectory)
                .foregroundStyle(.white)
                .frame(height: 16.0)
        }
        .onAppear {
            directorySearch.currentPrompt = queryText
        }
        .onChange(of: queryText) {
            directorySearch.currentPrompt = queryText
        }
        .font(.manrope(14.0))
    }
}

#Preview {
    DirectoryRecommendationView(queryText: .constant(""))
}

//
//  SearchBar.swift
//  Vault
//
//  Created by Austin Vesich on 5/18/24.
//

import SwiftUI

struct SearchBar: View {
    
    // MARK: - Constants
    private let TEMP_PROFILE_INDEX_OFFSET = 1

    // MARK: - Properties
    @Binding var usingAI: Bool
    @Binding var searchModel: Search
    var directoryProfiles: [DirectoryProfile]
    @Binding var temporaryProfile: DirectoryProfile
    @Binding var selectedProfileIndex: Int?
    @State private var searchQuery = ""

    private var currentProfile: DirectoryProfile {
        if selectedProfileIndex == 0 {
            return temporaryProfile
        }
        return directoryProfiles[selectedProfileIndex! - TEMP_PROFILE_INDEX_OFFSET]
    }

    // MARK: - UI
    var body: some View {
        HStack(spacing: 14.0) {
            Image(systemName: "magnifyingglass")
                .imageScale(.large)
            TextField(text: $searchQuery,
                      prompt: Text("Search...")) {}
                .font(.manrope(18.0))
                .textFieldStyle(.plain)
                .onChange(of: searchQuery) {
                    if let first = searchQuery.first,
                       first == "/" {
                        Task {
                            await searchModel.search(withQuery: searchQuery, withActiveDirectory: currentProfile.directoryPath)
                        }
                    }
                }
                .onSubmit {
                    Task {
                        await searchModel.search(withQuery: searchQuery, withActiveDirectory: currentProfile.directoryPath)
                    }
                }
            Spacer()
            Button {
                usingAI.toggle()
            } label: {
                Image(systemName: "sparkles")
                    .imageScale(.large)
                Text("⌘ + A")
            }
            .buttonStyle(.borderless)
            .font(.manrope(10.0, weight: .bold))
            .foregroundStyle(usingAI ? Color.purple : .secondary)
            .keyboardShortcut("a", modifiers: [.command])
            .shadow(color: usingAI ? .black.opacity(0.3) : .clear, radius: 3.0)
        }
        .padding(.vertical, 6.0)
    }
}

#Preview {
    SearchBar(usingAI: .constant(false),
              searchModel: .constant(Search()),
              directoryProfiles: [],
              temporaryProfile: .constant(.temporaryProfile),
              selectedProfileIndex: .constant(0))
}

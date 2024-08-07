//
//  SearchBar.swift
//  Vault
//
//  Created by Austin Vesich on 5/18/24.
//

import SwiftUI
import SwiftData

struct SearchBar: View {
    
    // MARK: - Constants
    private let TEMP_PROFILE_INDEX_OFFSET = 1

    // MARK: - Properties
    @Environment(GlobalSearch.self) var searchModel
    @Binding var usingAI: Bool
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
            TextField(text: searchModel.queryBinding,
                      prompt: Text("Search...")) {}
                .font(.manrope(18.0))
                .textFieldStyle(.plain)
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
        .onKeyPress(.return) {
            searchModel.specialAction()
            return .handled
        }
        .onKeyPress(.upArrow) {
            searchModel.moveSelectionUp()
            return .handled
        }
        .onKeyPress(.downArrow) {
            searchModel.moveSelectionDown()
            return .handled
        }
    }
}

#Preview {
    let dummyContainer = try! ModelContainer(for: Search.self)

    SearchBar(usingAI: .constant(false),
              directoryProfiles: [],
              temporaryProfile: .constant(.temporaryProfile),
              selectedProfileIndex: .constant(0))
    .environment(GlobalSearch(modelContext: dummyContainer.mainContext))
}

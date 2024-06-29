//
//  ContentView.swift
//  Vault
//
//  Created by Austin Vesich on 5/17/24.
//

import SwiftUI
import SwiftData

struct MainSearch: View {
    
    @Environment(GlobalSearch.self) var searchModel
    @Environment(\.modelContext) private var modelContext
    @Binding var usingAI: Bool
    @Query private var directoryProfiles: [DirectoryProfile]
    @State private var temporaryProfile: DirectoryProfile = .temporaryProfile
    @State private var selectedProfileIndex: Int? = 0
    @State private var scrollViewSize: CGSize = .zero

    var body: some View {
        VStack(spacing: 0.0) {
                VStack {
//                    DirectoryUI(usingAI: $usingAI,
//                                directoryProfiles: directoryProfiles,
//                                temporaryProfile: $temporaryProfile,
//                                selectedProfileIndex: $selectedProfileIndex)
//                    Divider()
//                        .padding(.top, 2.0)
                    ModeNameBar()
                    SearchBar(usingAI: $usingAI,
                              directoryProfiles: directoryProfiles,
                              temporaryProfile: $temporaryProfile,
                              selectedProfileIndex: $selectedProfileIndex)
                }
                .padding(.horizontal, 16.0)
                .padding(.vertical, 8.0)
                ResultFilterList()
                ResultsList()
            }
            .background(Material.regular)
            .clipShape(RoundedRectangle(cornerRadius: 16.0))
            .frame(width: 600.0)
    }
}

#Preview {
    let dummyContainer = try! ModelContainer(for: Search.self)

    MainSearch(usingAI: .constant(false))
        .environment(GlobalSearch(modelContext: dummyContainer.mainContext))
        .modelContainer(for: DirectoryProfile.self, inMemory: true)
}

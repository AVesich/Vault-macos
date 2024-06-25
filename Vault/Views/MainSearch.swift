//
//  ContentView.swift
//  Vault
//
//  Created by Austin Vesich on 5/17/24.
//

import SwiftUI
import SwiftData

struct MainSearch: View {
    
    @Environment(Search.self) var searchModel
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
                    if searchModel.searchMode != .modes {
                        HStack(spacing: 8.0) {
                            searchModel.searchMode.icon
                                .imageScale(.medium)
                            Text(searchModel.searchMode.rawValue)
                                .font(.manrope(12.0, weight: .semibold))
                            Spacer()
                        }
                        .foregroundColor(.white.opacity(0.6))
                        .padding(.vertical, 2.0)
                        Divider()
                    }
                    
                    SearchBar(usingAI: $usingAI,
                              directoryProfiles: directoryProfiles,
                              temporaryProfile: $temporaryProfile,
                              selectedProfileIndex: $selectedProfileIndex)
                }
                .padding(.horizontal, 16.0)
                .padding(.vertical, 8.0)
                ResultsList()
            }
            .background(Material.regular)
            .clipShape(RoundedRectangle(cornerRadius: 16.0))
            .frame(width: 600.0)
    }
}

#Preview {
    MainSearch(usingAI: .constant(false))
        .environment(Search())
        .modelContainer(for: DirectoryProfile.self, inMemory: true)
}

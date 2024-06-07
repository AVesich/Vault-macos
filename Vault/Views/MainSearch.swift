//
//  ContentView.swift
//  Vault
//
//  Created by Austin Vesich on 5/17/24.
//

import SwiftUI
import SwiftData

struct MainSearch: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var directoryProfiles: [DirectoryProfile]
    @State private var temporaryProfile: DirectoryProfile = .temporaryProfile
    @State private var selectedProfileIndex: Int? = 0
    @State private var usingAI = false
    @State private var searchModel = Search()

    var body: some View {
        VStack {
            VStack {
                DirectoryUI(usingAI: $usingAI,
                            directoryProfiles: directoryProfiles,
                            temporaryProfile: $temporaryProfile,
                            selectedProfileIndex: $selectedProfileIndex)
                Divider()
                    .padding(.top, 2.0)
                SearchBar(usingAI: $usingAI, 
                          searchModel: $searchModel,
                          directoryProfiles: directoryProfiles,
                          temporaryProfile: $temporaryProfile,
                          selectedProfileIndex: $selectedProfileIndex)
                Divider()
                ResultsList(results: $searchModel.results)
            }
            .padding(.horizontal, 16.0)
            .padding(.vertical, 20.0)
        }
        .background(Material.regular)
        .clipShape(RoundedRectangle(cornerRadius: 16.0))
        .frame(width: 600.0)
    }
}

#Preview {
    MainSearch()
        .modelContainer(for: DirectoryProfile.self, inMemory: true)
}

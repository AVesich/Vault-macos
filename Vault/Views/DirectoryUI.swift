//
//  DirectoryUI.swift
//  Vault
//
//  Created by Austin Vesich on 5/25/24.
//

import SwiftUI
import SwiftData

struct DirectoryUI: View {
    
    @Environment(\.modelContext) private var modelContext
    @Binding var usingAI: Bool
    @Query var directoryProfiles: [DirectoryProfile]
    @State private var selectedProfileIndex = -1
    
    private var currentProfile: DirectoryProfile {
        if selectedProfileIndex > 0 {
            return directoryProfiles[selectedProfileIndex]
        } 
        return .temporaryProfile
    }
    private var currentProfileDirectoryPath: String {
        return currentProfile.directoryPath
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4.0) {
            HStack {
                DirectorySearchBar(usingAI: $usingAI,
                                   searchQuery: Bindable(wrappedValue: currentProfile).directoryPath)
                DirectoryProfileSelector(profiles: directoryProfiles,
                                         selectedProfileIndex: $selectedProfileIndex)
            }
            if !usingAI && !currentProfileDirectoryPath.isEmpty {
                DirectoryRecommendationView(queryText: Bindable(wrappedValue: currentProfile).directoryPath)
            }
        }
    }
}

#Preview {
    DirectoryUI(usingAI: .constant(false))
        .modelContainer(for: DirectoryProfile.self, inMemory: true)
}

//
//  DirectoryUI.swift
//  Vault
//
//  Created by Austin Vesich on 5/25/24.
//

import SwiftUI
import SwiftData

struct DirectoryUI: View {
    
    // MARK: - Constants
    private let TEMP_PROFILE_INDEX_OFFSET = 1
    
    // MARK: - Properties
    @Environment(\.modelContext) private var modelContext
    @Binding var usingAI: Bool
    @Query private var directoryProfiles: [DirectoryProfile]
    @State private var temporaryProfile: DirectoryProfile = .temporaryProfile
    @State private var selectedProfileIndex: Int? = 0
    
    private var currentProfile: DirectoryProfile {
        if selectedProfileIndex == 0 {
            return temporaryProfile
        }
        return directoryProfiles[selectedProfileIndex! - TEMP_PROFILE_INDEX_OFFSET]
    }
    
    // MARK: - UI
    var body: some View {
        VStack(alignment: .leading, spacing: 4.0) {
            HStack {
                DirectorySearchBar(usingAI: $usingAI,
                                   tempProfile: $temporaryProfile,
                                   profiles: directoryProfiles,
                                   selectedProfileIndex: $selectedProfileIndex)
                DirectoryProfileSelector(profiles: directoryProfiles,
                                         selectedProfileIndex: $selectedProfileIndex)
            }
            if !usingAI && !currentProfile.directoryPath.isEmpty {
                DirectoryRecommendationView(profiles: directoryProfiles,
                                            tempProfile: $temporaryProfile,
                                            selectedProfileIndex: $selectedProfileIndex)
            }
        }
        
    }
}

#Preview {
    DirectoryUI(usingAI: .constant(false))
        .modelContainer(for: DirectoryProfile.self, inMemory: true)
}

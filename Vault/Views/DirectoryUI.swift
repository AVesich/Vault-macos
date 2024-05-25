//
//  DirectoryUI.swift
//  Vault
//
//  Created by Austin Vesich on 5/25/24.
//

import SwiftUI
import SwiftData

struct DirectoryUI: View {
    
    // MARK: - Properties
    @Environment(\.modelContext) private var modelContext
    @Binding var usingAI: Bool
    @Query private var directoryProfiles: [DirectoryProfile]
    @State private var temporaryProfile: DirectoryProfile = .temporaryProfile
    @State private var tempProfileIsActive: Bool = true
    @State private var selectedProfileIndex: Int = 0
    
    // MARK: - Methods & Computed properties
    private var currentProfile: DirectoryProfile {
        if tempProfileIsActive {
            return temporaryProfile
        }
        return directoryProfiles[selectedProfileIndex]
    }
    
    private var currentProfileDirectoryPath: String {
        return currentProfile.directoryPath
    }
    
    // MARK: - UI
    var body: some View {
        VStack(alignment: .leading, spacing: 4.0) {
            HStack {
                DirectorySearchBar(usingAI: $usingAI,
                                   tempProfile: $temporaryProfile,
                                   profiles: directoryProfiles)
                DirectoryProfileSelector(profiles: directoryProfiles,
                                         tempProfileIsActive: $tempProfileIsActive,
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

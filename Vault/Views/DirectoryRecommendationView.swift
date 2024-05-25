//
//  DirectoryRecommendationView.swift
//  Vault
//
//  Created by Austin Vesich on 5/25/24.
//

import SwiftUI

struct DirectoryRecommendationView: View {
    
    // MARK: - Constants
    private let TEMP_PROFILE_INDEX_OFFSET = 1

    // MARK: - Properties
    public var profiles: [DirectoryProfile]
    @Binding var tempProfile: DirectoryProfile
    @Binding var selectedProfileIndex: Int?
    @State private var directorySearch = DirectorySearch()

    // MARK: - Computed Properties
    private var tempProfileIsActive: Bool {
        return selectedProfileIndex == 0
    }
    private var currentSearch: String {
        if tempProfileIsActive {
            return tempProfile.directoryPath
        }
        return profiles[selectedProfileIndex! - TEMP_PROFILE_INDEX_OFFSET].directoryPath
    }
            
    // MARK: - UI
    var body: some View {
        HStack(spacing: 14.0) {
            Button() {
                autofillCurrentQuery()
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
        .onChange(of: selectedProfileIndex, initial: true) {
            updateDirectorySearchQuery()
        }
        .onChange(of: tempProfileIsActive) {
            updateDirectorySearchQuery()
        }
        .onChange(of: currentSearch) {
            updateDirectorySearchQuery()
        }
        .font(.manrope(14.0))
    }
    
    private func autofillCurrentQuery() {
        if tempProfileIsActive {
            tempProfile.directoryPath = directorySearch.autofilledCurrentQuery()
        } else {
            profiles[selectedProfileIndex! - TEMP_PROFILE_INDEX_OFFSET].directoryPath = directorySearch.autofilledCurrentQuery()
        }
    }
    
    private func updateDirectorySearchQuery() {
        directorySearch.currentPrompt = currentSearch
    }
}

#Preview {
    DirectoryRecommendationView(profiles: [],
                                tempProfile: .constant(.temporaryProfile),
                                selectedProfileIndex: .constant(0))
}

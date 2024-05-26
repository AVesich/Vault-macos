//
//  DirectoryProfileSelector.swift
//  Vault
//
//  Created by Austin Vesich on 5/23/24.
//

import SwiftUI
import SwiftData

struct DirectoryProfileSelector: View {
    
    // MARK: - Constants
    private let TEMP_PROFILE_INDEX_OFFSET = 1

    // MARK: - Properties
    @Environment(\.modelContext) private var modelContext
    public var profiles: [DirectoryProfile]
    @Binding var selectedProfileIndex: Int?
    
    // MARK: - Computed Properties
    private var tempProfileIsActive: Bool {
        return selectedProfileIndex == 0
    }
    private var favoriteButtonColor: Color {
        if tempProfileIsActive {
            return .secondary
        } else {
            return .yellow
        }
    }
    
    // MARK: - UI
    var body: some View {
        HStack {
            Button {
                if tempProfileIsActive {
                    addDirectoryConfig()
                } else {
                    removeDirectoryConfig()
                }
            } label: {
                Image(systemName: "star.fill")
                    .foregroundStyle(favoriteButtonColor)
            }
            .keyboardShortcut("f", modifiers: [.command])
            
            Divider()
                .frame(width: 1.0, height: 14.0)
                .padding(.horizontal, 4.0)
            
            HStack(spacing: 12.0) {
                Button {
                    selectedProfileIndex = 0
                } label: {
                    Text("⌛")
                        .font(.system(size: 14.0))
                        .opacity(tempProfileIsActive ? 1.0 : 0.5)
                        .shadow(color: .black.opacity(tempProfileIsActive ? 0.4 : 0.0),
                                radius: 4.0)
                }
                
                ForEach(Array(profiles.enumerated()),
                        id: \.offset) { i, config in
                    Button {
                        selectedProfileIndex = i + TEMP_PROFILE_INDEX_OFFSET
                    } label: {
                        Text(config.directoryEmoji)
                            .font(.system(size: 14.0))
                            .opacity((!tempProfileIsActive && selectedProfileIndex == i + TEMP_PROFILE_INDEX_OFFSET) ? 1.0 : 0.5)
                            .shadow(color: .black.opacity((!tempProfileIsActive && selectedProfileIndex == i + TEMP_PROFILE_INDEX_OFFSET) ? 0.4 : 0.0),
                                    radius: 4.0)
                    }
                }
            }
        }
        .buttonStyle(.borderless)
        .onAppear {
            if !profiles.isEmpty {
                selectedProfileIndex = 0
            }
        }
    }
        
    private func addDirectoryConfig() {
        modelContext.insert(DirectoryProfile.temporaryProfile)
        selectedProfileIndex = 1
    }
    
    private func removeDirectoryConfig() {
        modelContext.delete(profiles[selectedProfileIndex! - TEMP_PROFILE_INDEX_OFFSET])
        selectedProfileIndex = 0
    }
}

#Preview {
    DirectoryProfileSelector(profiles: [],
                             selectedProfileIndex: .constant(0))
        .modelContainer(for: DirectoryProfile.self, inMemory: true)
}

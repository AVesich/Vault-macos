//
//  DirectoryProfileSelector.swift
//  Vault
//
//  Created by Austin Vesich on 5/23/24.
//

import SwiftUI
import SwiftData

struct DirectoryProfileSelector: View {
    
    @Environment(\.modelContext) private var modelContext
    public var profiles: [DirectoryProfile]
    @Binding var selectedProfileIndex: Int
    private let NEW_CONFIG_INDEX = -1
    private var indexIsNew: Bool {
        return selectedProfileIndex == NEW_CONFIG_INDEX
    }
    private var favoriteButtonColor: Color {
        if indexIsNew {
            return .secondary
        } else {
            return profiles[selectedProfileIndex].isFavorited ? .yellow : .secondary
        }
    }
    
    var body: some View {
        HStack {
            Button {
                if indexIsNew {
                    addDirectoryConfig()
                } else {
                    if profiles[selectedProfileIndex].isFavorited {
                        removeDirectoryConfig()
                    } else {
                        profiles[selectedProfileIndex].isFavorited.toggle()
                    }
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
                ForEach(Array(profiles.enumerated()),
                        id: \.offset) { i, config in
                    Button {
                        selectedProfileIndex = i
                    } label: {
                        Text(config.directoryEmoji)
                            .font(.system(size: 14.0))
                            .frame(width: 16.0, height: 16.0)
                            .opacity(selectedProfileIndex == i ? 1.0 : 0.5)
                            .shadow(color: .black.opacity(selectedProfileIndex == i ? 0.4 : 0.0),
                                    radius: 4.0)
                    }
                }
                
                if selectedProfileIndex >= 0 {
                    Button {
                        addDirectoryConfig()
                    } label: {
                        Image(systemName: "plus")
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
        selectedProfileIndex = profiles.count-1
    }
    
    private func removeDirectoryConfig() {
        modelContext.delete(profiles[selectedProfileIndex])
        if selectedProfileIndex > profiles.count-1 {
            selectedProfileIndex = (selectedProfileIndex-1 >= 0) ? selectedProfileIndex-1 : NEW_CONFIG_INDEX
        }
    }
}

#Preview {
    DirectoryProfileSelector(profiles: [], selectedProfileIndex: .constant(0))
        .modelContainer(for: DirectoryProfile.self, inMemory: true)
}

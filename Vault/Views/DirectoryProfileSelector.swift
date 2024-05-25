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
    @Binding var tempProfileIsActive: Bool
    @Binding var selectedProfileIndex: Int
    private var favoriteButtonColor: Color {
        if tempProfileIsActive {
            return .secondary
        } else {
            return .yellow
        }
    }
    
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
                    tempProfileIsActive = true
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
                        selectedProfileIndex = i
                        tempProfileIsActive = false
                    } label: {
                        Text(config.directoryEmoji)
                            .font(.system(size: 14.0))
                            .opacity((!tempProfileIsActive && selectedProfileIndex == i) ? 1.0 : 0.5)
                            .shadow(color: .black.opacity((!tempProfileIsActive && selectedProfileIndex == i) ? 0.4 : 0.0),
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
        tempProfileIsActive = false
        selectedProfileIndex = profiles.count-1
    }
    
    private func removeDirectoryConfig() {
        modelContext.delete(profiles[selectedProfileIndex])
        tempProfileIsActive = true
        saveSelectedIndex()
    }
    
    private func saveSelectedIndex() {
        UserDefaults.standard.setValue(selectedProfileIndex, forKey: "selectedProfileIndex")
    }
}

#Preview {
    DirectoryProfileSelector(profiles: [],
                             tempProfileIsActive: .constant(true),
                             selectedProfileIndex: .constant(0))
        .modelContainer(for: DirectoryProfile.self, inMemory: true)
}

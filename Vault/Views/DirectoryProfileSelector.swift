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
    @Query private var directoryConfigs: [DirectoryConfig]
    @Binding var selectedIndex: Int
    private let thing = DirectoryConfig(directoryPath: "/Users/austin",
                                directoryEmoji: "👨🏻",
                                isFavorited: true)
    private let NEW_CONFIG_INDEX = -1
    private var indexIsNew: Bool {
        return selectedIndex == NEW_CONFIG_INDEX
    }
    private var favoriteButtonColor: Color {
        if indexIsNew {
            return .secondary
        } else {
            return directoryConfigs[selectedIndex].isFavorited ? .yellow : .secondary
        }
    }
    
    var body: some View {
        HStack {
            Button {
                if indexIsNew {
                    addDirectoryConfig()
                } else {
                    if directoryConfigs[selectedIndex].isFavorited {
                        removeDirectoryConfig()
                    } else {
                        directoryConfigs[selectedIndex].isFavorited.toggle()
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
                ForEach(Array(directoryConfigs.enumerated()),
                        id: \.offset) { i, config in
                    Button {
                        selectedIndex = i
                    } label: {
                        Text(config.directoryEmoji)
                            .font(.system(size: 14.0))
                            .frame(width: 16.0, height: 16.0)
                            .opacity(selectedIndex == i ? 1.0 : 0.5)
                            .shadow(color: .black.opacity(selectedIndex == i ? 0.4 : 0.0),
                                    radius: 4.0)
                    }
                }
                
                if selectedIndex >= 0 {
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
            if !directoryConfigs.isEmpty {
                selectedIndex = 0
            }
        }
    }
    
    private func addDirectoryConfig() {
        modelContext.insert(thing)
        selectedIndex = directoryConfigs.count-1
    }
    
    private func removeDirectoryConfig() {
        modelContext.delete(directoryConfigs[selectedIndex])
        if selectedIndex > directoryConfigs.count-1 {
            selectedIndex = (selectedIndex-1 >= 0) ? selectedIndex-1 : NEW_CONFIG_INDEX
        }
    }
}

#Preview {
    DirectoryProfileSelector(selectedIndex: .constant(0))
        .modelContainer(for: DirectoryConfig.self, inMemory: true)
}

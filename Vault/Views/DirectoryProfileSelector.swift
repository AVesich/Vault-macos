//
//  DirectoryProfileSelector.swift
//  Vault
//
//  Created by Austin Vesich on 5/23/24.
//

import SwiftUI

struct DirectoryProfileSelector: View {
    
    @State private var profiles = [DirectoryConfig(directoryPath: "/Users/austin",
                                                   directoryEmoji: "👨🏻",
                                                   isFavorited: true)]
    
    var body: some View {
        HStack {
            Toggle(isOn: $profiles[0].isFavorited) {}
                .toggleStyle(FavoriteStyle())
            
            Divider()
                .frame(width: 1.0, height: 10.0)
                .padding(.horizontal, 4.0)
            
            HStack(spacing: 8.0) {
                ForEach(profiles) { profile in
                    Text(profile.directoryEmoji)
                        .font(.system(size: 10.0))
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "plus")
                }
                .buttonStyle(.borderless)
            }
        }
    }
}

#Preview {
    DirectoryProfileSelector()
//        .modelContainer(for: DirectoryConfig.self, inMemory: true)
}

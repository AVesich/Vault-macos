//
//  DirectorySearch.swift
//  Vault
//
//  Created by Austin Vesich on 5/18/24.
//

import SwiftUI

struct DirectorySearchBar: View {
    
    // MARK: - Constants
    private let FOLDER_ICON_SIZE = 30.0

    // MARK: - Properties
    @Binding var usingAI: Bool
    @Binding var tempProfile: DirectoryProfile
    public var profiles: [DirectoryProfile]
    @Binding var selectedProfileIndex: Int?
    
    // MARK: - UI
    var body: some View {
        GeometryReader { geometry in
            HStack (alignment: .center, spacing: 14.0) {
                Image(systemName: "folder.fill")
                    .imageScale(.small)
                    .opacity(0.4)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack() {
                        TextField(text: $tempProfile.directoryPath,
                                  prompt: Text("/Users/")) {}
                            .textFieldStyle(.plain)
                            .frame(width: geometry.size.width - FOLDER_ICON_SIZE)
                            .id(0)
                        ForEach(Array(profiles.enumerated()), id: \.offset) { i, profile in
                            TextField(text: Bindable(profile).directoryPath,
                                      prompt: Text("/Users/")) {}
                                .textFieldStyle(.plain)
                                .frame(width: geometry.size.width - FOLDER_ICON_SIZE)
                                .id(i+1)
                        }
                    }
                    .scrollTargetLayout()
                }
                .frame(height: 16.0)
                .scrollTargetBehavior(.viewAligned)
                .scrollPosition(id: $selectedProfileIndex)
            }
            .font(.manrope(14.0))
            .padding(.vertical, 4.0)
        }
        .frame(height: 16.0)
    }
}

#Preview {
    DirectorySearchBar(usingAI: .constant(false),
                       tempProfile: .constant(.temporaryProfile),
                       profiles: [.temporaryProfile, .temporaryProfile],
                       selectedProfileIndex: .constant(0))
}

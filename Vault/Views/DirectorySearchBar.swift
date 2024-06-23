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
    private let TEMP_PROFILE_INDEX_OFFSET = 1

    // MARK: - Properties
    @Binding var usingAI: Bool
    @Binding var tempProfile: DirectoryProfile
    public var profiles: [DirectoryProfile]
    @Binding var selectedProfileIndex: Int?
    @Binding var directorySearchModel: DirectorySearch
    private var currentProfile: DirectoryProfile {
        if selectedProfileIndex == 0 {
            return tempProfile
        }
        return profiles[selectedProfileIndex! - TEMP_PROFILE_INDEX_OFFSET]
    }
    
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
        .onChange(of: selectedProfileIndex, initial: true) {
            if let selectedProfileIndex {
                if selectedProfileIndex == 0 {
                    directorySearchModel.queryText = $tempProfile.directoryPath
                } else {
                    directorySearchModel.queryText = Bindable(profiles[selectedProfileIndex - TEMP_PROFILE_INDEX_OFFSET]).directoryPath
                }
            }
        }
        .onChange(of: currentProfile.directoryPath, initial: true) {
            directorySearchModel.updateSuggestedDirectories()
        }
    }
}

#Preview {
    DirectorySearchBar(usingAI: .constant(false),
                       tempProfile: .constant(.temporaryProfile),
                       profiles: [.temporaryProfile, .temporaryProfile],
                       selectedProfileIndex: .constant(0),
                       directorySearchModel: .constant(DirectorySearch()))
}

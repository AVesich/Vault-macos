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
            VStack(alignment: .leading, spacing: 4.0) {
                HStack (spacing: 14.0) {
                    Image(systemName: "folder.fill")
                        .imageScale(.small)
                        .opacity(0.4)
                    
                    ScrollView(.horizontal) {
                        LazyHStack() {
                            TextField(text: $tempProfile.directoryPath,
                                      prompt: Text("/Users/")) {}
                                .textFieldStyle(.plain)
                                .frame(width: geometry.size.width - FOLDER_ICON_SIZE, height: 16.0)
                                .id(0)
                            ForEach(Array(profiles.enumerated()), id: \.offset) { i, profile in
                                TextField(text: Bindable(profile).directoryPath,
                                          prompt: Text("/Users/")) {}
                                    .textFieldStyle(.plain)
                                    .frame(width: geometry.size.width - FOLDER_ICON_SIZE, height: 16.0)
                                    .id(i+1)
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(.viewAligned)
                    .scrollPosition(id: $selectedProfileIndex)
                    .scrollIndicators(.hidden)
                }
            }
            .font(.manrope(14.0))
            .padding(.vertical, 4.0)
        }
    }
}

#Preview {
    DirectorySearchBar(usingAI: .constant(false),
                       tempProfile: .constant(.temporaryProfile),
                       profiles: [.temporaryProfile, .temporaryProfile],
                       selectedProfileIndex: .constant(0))
}

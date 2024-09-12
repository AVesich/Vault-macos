//
//  ModeNameBar.swift
//  Vault
//
//  Created by Austin Vesich on 6/25/24.
//

import SwiftUI
import SwiftData

struct ModeNameBar: View {
    
    @Environment(GlobalSearch.self) var searchModel
    
    var body: some View {
        if searchModel.activeMode.modeFilterType != .mode {
            HStack(spacing: 8.0) {
                Image(systemName: searchModel.activeMode.iconName)
                    .imageScale(.medium)
                Text(searchModel.activeMode.name)
                    .font(.manrope(12.0, weight: .semibold))
                Spacer()
            }
            .foregroundColor(.white.opacity(0.6))
            .padding(.vertical, 2.0)
            Divider()
        }
    }
}

#Preview {
    let dummyContainer = try! ModelContainer(for: Search.self)

    ModeNameBar()
        .environment(GlobalSearch(modelContext: dummyContainer.mainContext))
}

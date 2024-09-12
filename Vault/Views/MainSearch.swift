//
//  ContentView.swift
//  Vault
//
//  Created by Austin Vesich on 5/17/24.
//

import SwiftUI
import SwiftData

struct MainSearch: View {
    
    @Environment(GlobalSearch.self) var searchModel
    @Environment(\.modelContext) private var modelContext
    @Binding var usingAI: Bool
    @State private var scrollViewSize: CGSize = .zero

    var body: some View {
        VStack(spacing: 0.0) {
                VStack {
                    ModeNameBar()
                    SearchBar(usingAI: $usingAI)
                }
                .padding(.horizontal, 16.0)
                .padding(.vertical, 8.0)
                ResultFilterList()
                ResultsList()
            }
            .background(Material.regular)
            .clipShape(RoundedRectangle(cornerRadius: 16.0))
            .frame(width: 600.0)
    }
}

#Preview {
    let dummyContainer = try! ModelContainer(for: Search.self)

    MainSearch(usingAI: .constant(false))
        .environment(GlobalSearch(modelContext: dummyContainer.mainContext))
}

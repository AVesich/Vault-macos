//
//  TextResult.swift
//  Vault
//
//  Created by Austin Vesich on 6/18/24.
//

import SwiftUI

struct SearchModeResultView: View {
    
    @Environment(GlobalSearch.self) var searchModel
    @State private var isHovering: Bool = false
    var searchMode: SearchMode

    var body: some View {
        HStack {
            if let first = searchModel.results.first?.content as? SearchMode,
               first === searchMode {
                Image(systemName: "return")
                    .fontWeight(.bold)
                    .imageScale(.small)
                    .offset(y: 1.0)
            }
            Text(searchMode.name)
                .font(.manrope(16.0))
            Spacer()
        }
        .frame(height: 28.0)
        .onTapGesture {
            searchModel.activeMode = searchMode
        }
    }
}

#Preview {
    SearchModeResultView(searchMode: SearchMode(name: "GitHub",
                                                systemIconName: "cat.fill",
                                                engine: GitHubSearchEngine()))
        .environment(GlobalSearch())
}

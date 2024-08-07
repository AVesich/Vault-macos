//
//  TextResult.swift
//  Vault
//
//  Created by Austin Vesich on 6/18/24.
//

import SwiftUI
import SwiftData

struct TextResultView: View {
    
    @Environment(GlobalSearch.self) var searchModel
    var result: any SearchResult
    var text: String

    var body: some View {
        HStack {
            if let first = searchModel.publishedResults.first?.content as? (any SearchResult),
               first.id == result.id {
                Image(systemName: "return")
                    .fontWeight(.bold)
                    .imageScale(.small)
                    .offset(y: 1.0)
            }
            Text(text)
                .font(.manrope(16.0))
            Spacer()
        }
        .frame(height: 28.0)
    }
}

#Preview {
    let dummyContainer = try! ModelContainer(for: Search.self)
    
    TextResultView(result: ModeResult(content: SearchMode(modeType: .github,
                                                          systemIconName: "cat.fill",
                                                          engine: GitHubSearchEngine())),
                   text: "GitHub")
        .environment(GlobalSearch(modelContext: dummyContainer.mainContext))
}

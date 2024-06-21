//
//  TextResult.swift
//  Vault
//
//  Created by Austin Vesich on 6/18/24.
//

import SwiftUI

struct SearchModeResult: View {
    
    @Environment(Search.self) var searchModel
    @State private var isHovering: Bool = false
    var searchResult: SearchResult

    var body: some View {
        HStack {
            if let first = searchModel.results.first,
               first == searchResult {
                Image(systemName: "return")
                    .fontWeight(.bold)
                    .imageScale(.small)
                    .offset(y: 1.0)
            }
            Text(searchResult.searchMode!.rawValue)
                .font(.manrope(16.0))
            Spacer()
        }
        .frame(height: 28.0)
        .padding(.leading, 8.0)
        .background {
            RoundedRectangle(cornerRadius: 4.0)
                .fill(isHovering ? .white.opacity(0.1) : .clear)
                .animation(.easeOut(duration: 0.1), value: isHovering)
        }
        .onHover { hovering in
            isHovering = hovering
        }
        .onTapGesture {
            searchModel.searchMode = searchResult.searchMode!
        }
    }
}

#Preview {
    SearchModeResult(searchResult: SearchResult(searchMode: .gitHub))
        .environment(Search())
}

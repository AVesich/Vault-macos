//
//  TextResult.swift
//  Vault
//
//  Created by Austin Vesich on 6/18/24.
//

import SwiftUI

struct SearchModeResultView: View {
    
    @Environment(Search.self) var searchModel
    @State private var isHovering: Bool = false
    var searchMode: SearchModeType

    var body: some View {
        HStack {
            if let first = searchModel.results.first?.content as? SearchModeType,
               first == searchMode {
                Image(systemName: "return")
                    .fontWeight(.bold)
                    .imageScale(.small)
                    .offset(y: 1.0)
            }
            Text(searchMode.rawValue)
                .font(.manrope(16.0))
            Spacer()
        }
        .frame(height: 28.0)
        .onTapGesture {
            searchModel.searchMode = searchMode
        }
    }
}

#Preview {
    SearchModeResultView(searchMode: .gitHub)
        .environment(Search())
}

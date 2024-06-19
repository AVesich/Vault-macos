//
//  TextResult.swift
//  Vault
//
//  Created by Austin Vesich on 6/18/24.
//

import SwiftUI

struct TextResult: View {
    
    var searchResult: SearchResult

    var body: some View {
        HStack {
            Text(searchResult.text!)
                .font(.manrope(18.0))
                .padding(.bottom, 2.0)
            Spacer()
        }
    }
}

#Preview {
    TextResult(searchResult: SearchResult(text: "/GitHub"))
}

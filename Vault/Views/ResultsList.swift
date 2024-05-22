//
//  ResultsList.swift
//  Vault
//
//  Created by Austin Vesich on 5/22/24.
//

import SwiftUI

struct ResultsList: View {
    
    @Binding var results: [SearchResponse]
    
    var body: some View {
        if !results.isEmpty {
            ScrollView(.vertical) {
                Text(results[0].text ?? "No response.")
                    .font(.manrope(14.0))
            }
        }
    }
}

#Preview {
    ResultsList(results: .constant([]))
}

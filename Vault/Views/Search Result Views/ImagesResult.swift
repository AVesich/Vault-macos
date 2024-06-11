//
//  ImagesResultView.swift
//  Vault
//
//  Created by Austin Vesich on 6/10/24.
//

import SwiftUI

struct ImagesResult: View {
    
    public var searchResult: SearchResult
    let columns: [GridItem] = [
        GridItem(.adaptive(minimum: .infinity, maximum: .infinity)),
        GridItem(.adaptive(minimum: .infinity, maximum: .infinity)),
        GridItem(.adaptive(minimum: .infinity, maximum: .infinity))
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 8.0) {
            ForEach(0..<searchResult.images!.count) { index in
                ResultImage(image: searchResult.images![index])
                    .frame(width: .infinity)
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 8.0))
            }
        }
        .frame(width: .infinity)
    }
}

#Preview {
    ImagesResult(searchResult: SearchResult(images: [
        Image(systemName: "plus"),
        Image(systemName: "person"),
        Image(systemName: "person.fill"),
        Image(systemName: "square.fill"),
        Image(systemName: "circle.fill")
    ]))
}

//
//  ImagesResultView.swift
//  Vault
//
//  Created by Austin Vesich on 6/10/24.
//

import SwiftUI

struct ImagesResult: View {
    
    public var searchResult: SearchResult

    var body: some View {
        HStack(spacing: 12.0) {
            VStack() {
                ForEach(Array(stride(from: 0, to: searchResult.imageURLs!.count, by: 3)), id: \.self) { index in
                    ResultImage(urls: searchResult.imageURLs![index])
                        .padding(.bottom, 4.0)
                }
                Spacer()
            }
            VStack {
                ForEach(Array(stride(from: 1, to: searchResult.imageURLs!.count, by: 3)), id: \.self) { index in
                    ResultImage(urls: searchResult.imageURLs![index])
                        .padding(.bottom, 4.0)
                }
                Spacer()
            }
            VStack {
                ForEach(Array(stride(from: 2, to: searchResult.imageURLs!.count, by: 3)), id: \.self) { index in
                    ResultImage(urls: searchResult.imageURLs![index])
                        .padding(.bottom, 4.0)
                }
                Spacer()
            }
        }
        .padding(.horizontal, 8.0)
    }
}

#Preview {
    ImagesResult(searchResult: SearchResult(imageURLs: []))
}

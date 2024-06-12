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
                ForEach(Array(stride(from: 0, to: searchResult.images!.count, by: 3)), id: \.self) { index in
                    ResultImage(image: searchResult.images![index])
                        .padding(.bottom, 4.0)
                }
                Spacer()
            }
            VStack {
                ForEach(Array(stride(from: 1, to: searchResult.images!.count, by: 3)), id: \.self) { index in
                    ResultImage(image: searchResult.images![index])
                }
                Spacer()
            }
            VStack {
                ForEach(Array(stride(from: 2, to: searchResult.images!.count, by: 3)), id: \.self) { index in
                    ResultImage(image: searchResult.images![index])
                }
                Spacer()
            }
        }
    }
}

#Preview {
    ImagesResult(searchResult: SearchResult(images: [
        Image("Test_Cat_1"),
        Image("Test_Cat_2"),
        Image("Test_Cat_3")
    ]))
}

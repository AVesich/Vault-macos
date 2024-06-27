//
//  ImagesResultView.swift
//  Vault
//
//  Created by Austin Vesich on 6/10/24.
//

import SwiftUI

struct ImagesResultView: View {
    
    public var photoURLs: [PhotoURLs]

    var body: some View {
        HStack(spacing: 12.0) {
            VStack() {
                ForEach(Array(stride(from: 0, to: photoURLs.count, by: 3)), id: \.self) { index in
                    ResultImageView(urls: photoURLs[index])
                        .padding(.bottom, 4.0)
                }
                Spacer()
            }
            VStack {
                ForEach(Array(stride(from: 1, to: photoURLs.count, by: 3)), id: \.self) { index in
                    ResultImageView(urls: photoURLs[index])
                        .padding(.bottom, 4.0)
                }
                Spacer()
            }
            VStack {
                ForEach(Array(stride(from: 2, to: photoURLs.count, by: 3)), id: \.self) { index in
                    ResultImageView(urls: photoURLs[index])
                        .padding(.bottom, 4.0)
                }
                Spacer()
            }
        }
        .padding(.horizontal, 8.0)
    }
}

#Preview {
    ImagesResultView(photoURLs: [])
}

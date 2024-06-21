//
//  ResultImage.swift
//  Vault
//
//  Created by Austin Vesich on 6/10/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct ResultImage: View {
    
    @State private var hovering: Bool = false
    public var urls: PhotoURLs
    @State private var data: Data? = nil
    
    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: urls.thumb)!) { result in
                result.image?
                    .resizable()
                    .scaledToFit()
            }
            .clipShape(RoundedRectangle(cornerRadius: 8.0))
            .scaleEffect(CGSize(width: hovering ? 1.05 : 1.0,
                                height: hovering ? 1.05 : 1.0))
        }
            .onHover(perform: { hovering in
                self.hovering = hovering
            })
            .animation(.spring(response: 0.35, dampingFraction: 0.45, blendDuration: 0.5), value: hovering)
            .onDrag {
                if let data {
                    return NSItemProvider(item: data as NSSecureCoding, typeIdentifier: UTType.image.identifier)
                }
                return NSItemProvider(item: nil, typeIdentifier: nil)
            }
            .task {
                data = await UnsplashAPI.getImageDataForURL(urls.raw)
            }
    }
}

#Preview {
    ResultImage(urls: PhotoURLs(raw:
                                    "https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?q=80&w=2043&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                                full: "https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?q=80&w=2043&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                                regular: "https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?q=80&w=2043&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                                small: "https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?q=80&w=2043&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                                thumb: "https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?q=80&w=2043&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"))
}

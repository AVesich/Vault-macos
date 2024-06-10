//
//  UnsplashAPI.swift
//  Vault
//
//  Created by Austin Vesich on 6/9/24.
//

import Foundation
import SwiftUI

struct UnsplashAPI {
    func searchPhotos(withQuery query: String) async -> [Image] {
        if let url = URL(string: "https://api.unsplash.com/search/photos?page=1&query=\(query)"),
           let (data, _) = try? await URLSession.shared.data(from: url) {
            let decoder = APIDecoder<UnsplashPhotoSearchResult>()
            let decodedResult = decoder.decodeValueFromData(data)
            if let decodedResult {
                return getImagesFromSearchResult(decodedResult)
            }
        }
        
        return [Image]()
    }
    
    private func getImagesFromSearchResult(_ searchResult: UnsplashPhotoSearchResult) -> [Image] {
        let smallURLs = searchResult.results.map { $0.urls.small }
        let images: [Image] = smallURLs.compactMap { smallURL in
            if let url = URL(string: smallURL),
               let data = try? Data(contentsOf: url),
               let nsImage = NSImage(data: data) {
                return Image(nsImage: nsImage)
            }
            return nil
        }
        
        return images
    }
}

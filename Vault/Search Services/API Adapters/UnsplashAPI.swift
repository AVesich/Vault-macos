//
//  UnsplashAPI.swift
//  Vault
//
//  Created by Austin Vesich on 6/9/24.
//

import Foundation
import SwiftUI

struct UnsplashAPI {
    private let API_URL = "https://api.unsplash.com"
    
    public func searchPhotos(withQuery query: String) async -> [Image] {
        if let url = URL(string: API_URL+"/search/photos/?client_id=\(PlistHelper.getAPIPlistValue(forKey: "UnsplashKey"))"),
           let (data, _) = try? await URLSession.shared.data(for: getSearchPhotosRequest(forURL: url, withQuery: query)) {
            let decoder = APIDecoder<UnsplashPhotoSearchResult>()
            let decodedResult = decoder.decodeValueFromData(data)
            if let decodedResult {
                return getImagesFromSearchResult(decodedResult)
            }
        }
        return [Image]()
    }
    
    private func getSearchPhotosRequest(forURL url: URL, withQuery query: String) -> URLRequest {
        let components = NSURLComponents(string: API_URL+"/search/photos/")!
        components.queryItems = [
            URLQueryItem(name: "query" , value: query),
            URLQueryItem(name: "client_id", value: PlistHelper.getAPIPlistValue(forKey: "UnsplashKey"))
        ]
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        return request
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

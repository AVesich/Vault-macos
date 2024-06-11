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
    private let SEARCH_PARAMS: Dictionary<String, String> = [
        PlistHelper.getAPIPlistValue(forKey: "UnsplashKey") : "client_id",
        "page" : "1",
        "per_page" : "10"
    ]
    
    public func searchPhotos(withQuery query: String) async -> [Image] {
        if let (data, _) = try? await URLSession.shared.data(for: getSearchPhotosRequest(forURLString: API_URL+"/search/photos/", withQuery: query)) {
            let decoder = APIDecoder<UnsplashPhotoSearchResult>()
            let decodedResult = decoder.decodeValueFromData(data)
            if let decodedResult {
                return getImagesFromSearchResult(decodedResult)
            }
        }
        return [Image]()
    }
    
    private func getSearchPhotosRequest(forURLString urlString: String, withQuery query: String) -> URLRequest {
        var params = SEARCH_PARAMS
        params["query"] = query
        if var request = APIJSONHelpers.getURLRequest(withURLString: urlString, andParams: params) {
            request.httpMethod = "GET"
            return request
        } else {
            return URLRequest(url: URL(string: API_URL+"/search/photos/?client_id=\(PlistHelper.getAPIPlistValue(forKey: "UnsplashKey"))")!)
        }
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

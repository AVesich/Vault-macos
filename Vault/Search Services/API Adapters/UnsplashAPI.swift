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
        "client_id" : PlistHelper.getAPIPlistValue(forKey: "UnsplashKey"),
        "page" : "1",
        "per_page" : "10"
    ]
    
    public func searchPhotos(withQuery query: String) async -> [Image] {
        if let (data, _) = try? await URLSession.shared.data(for: getSearchPhotosRequest(forURLString: API_URL+"/search/photos/?", withQuery: query)) {
//            print(String(data: data, encoding: .ascii))
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
            return URLRequest(url: URL(string: "")!)
        }
    }
    
    private func getImagesFromSearchResult(_ searchResult: UnsplashPhotoSearchResult) -> [Image] {
        let images: [Image] = searchResult.results.compactMap { result in
            if let url = URL(string: result.urls.thumb),
               let data = try? Data(contentsOf: url),
               let nsImage = NSImage(data: data) {
                return Image(nsImage: nsImage)
            }
            return nil
        }
        
        return images
    }
}

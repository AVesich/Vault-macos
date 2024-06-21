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
    
    public func searchPhotos(withQuery query: String) async -> [PhotoURLs] {
        if let (data, _) = try? await URLSession.shared.data(for: getSearchPhotosRequest(forURLString: API_URL+"/search/photos/?", withQuery: query)) {
            let decoder = APIDecoder<UnsplashPhotoSearchResult>()
            let decodedResult = decoder.decodeValueFromData(data)
            if let decodedResult {
                return getImagesURLsFromSearchResult(decodedResult)
            }
        }
        return [PhotoURLs]()
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
    
    private func getImagesURLsFromSearchResult(_ searchResult: UnsplashPhotoSearchResult) -> [PhotoURLs] {
        let photoURLs: [PhotoURLs] = searchResult.results.map { result in
            return result.urls
        }
        
        return photoURLs
    }
    
    public static func getImageDataForURL(_ urlString: String) async -> Data? {
        if let url = URL(string: urlString),
           let (data, _) = try? await URLSession.shared.data(from: url) {
            return data
        }
        return nil
    }
}

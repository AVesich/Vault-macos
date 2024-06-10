//
//  UnsplashResult.swift
//  Vault
//
//  Created by Austin Vesich on 6/9/24.
//

import Foundation

struct UnsplashPhotoSearchResult: Codable {
    var total: Int
    var total_pages: Int
    var results: [ResultData]
}

struct ResultData: Codable {
    var id: String
    var color: String
    var urls: PhotoURLs
}

struct PhotoURLs: Codable {
    var raw: String
    var full: String
    var regular: String
    var small: String
    var thumb: String
}

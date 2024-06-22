//
//  UnsplashSearchEngine.swift
//  Vault
//
//  Created by Austin Vesich on 6/9/24.
//

import Foundation

class UnsplashSearchEngine: Engine {
    
    public var delegate: EngineDelegate?
    internal var searchResults = [SearchResult]()
    private let API = UnsplashAPI()
    
    func search(withQuery query: String, inActiveDirectory activeDirectory: String) {
        Task {
            let resultPhotoURLs = await API.searchPhotos(withQuery: query)
            let result = SearchResult(imageURLs: resultPhotoURLs)
            delegate?.engineDidFindResults(results: [result])
        }
    }
}

protocol UnsplashSearchEngineDelegate: EngineDelegate {}

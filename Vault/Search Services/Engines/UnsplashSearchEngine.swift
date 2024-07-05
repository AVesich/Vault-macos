//
//  UnsplashSearchEngine.swift
//  Vault
//
//  Created by Austin Vesich on 6/9/24.
//

import Foundation

class UnsplashSearchEngine: Engine {
    
    public var delegate: EngineDelegate?
    internal var searchResults = [ImagesResult]() {
        didSet {
            delegate?.engineDidFindResults(results: searchResults)
        }
    }
    public var searchFilters = [SearchFilter]()
    public var autocomplete: (() -> ())? = nil
    private let API = UnsplashAPI()
    
    func search(withQuery query: String, inActiveDirectory activeDirectory: String) {
        Task {
            let resultPhotoURLs = await API.searchPhotos(withQuery: query)
            searchResults = [ImagesResult(content: resultPhotoURLs)]
        }
    }
}

protocol UnsplashSearchEngineDelegate: EngineDelegate {}

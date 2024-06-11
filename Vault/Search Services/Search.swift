//
//  SearchModel.swift
//  Vault
//
//  Created by Austin Vesich on 5/18/24.
//

import SwiftUI

@Observable class Search {
    
    private let fileSystemEngine = FileSystemSearchEngine()
    private let unsplashEngine = UnsplashSearchEngine()
//    private let generativeAI = GenerativeAI()
    public var results = [SearchResult]()
    
    init() {
        setupDelegates()
    }
    
    // MARK: - Methods
    private func setupDelegates() {
        fileSystemEngine.delegate = self
        unsplashEngine.delegate = self
    }
    
    public func search(withQuery query: String, withActiveDirectory activeDirectory: String) async {
        //await fileManagerSearch(withQuery: query, withActiveDirectory: activeDirectory)
        await unsplashSearch(withQuery: query, withActiveDirectory: activeDirectory)
    }
    
    private func fileManagerSearch(withQuery query: String, withActiveDirectory activeDirectory: String) async {
        await fileSystemEngine.search(withQuery: query, inActiveDirectory: activeDirectory)
    }
    
    private func unsplashSearch(withQuery query: String, withActiveDirectory activeDirectory: String) async {
        await unsplashEngine.search(withQuery: query, inActiveDirectory: activeDirectory)
    }
    
//    private func aiSearch(withQuery query: String) async -> [SearchResult] {
//        let aiResponse = await generativeAI.getResponse(to: query)
//        if !aiResponse.isEmpty {
//            let aiResponseData = SearchResult(text: aiResponse)
//            return [aiResponseData]
//        }
//        return [SearchResult]()
//    }
}

extension Search: EngineDelegate {
    func engineDidFindResults(results: [SearchResult]) {
        print(results)
        self.results = results
    }
}


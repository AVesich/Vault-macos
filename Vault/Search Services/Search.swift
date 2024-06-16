//
//  SearchModel.swift
//  Vault
//
//  Created by Austin Vesich on 5/18/24.
//

import SwiftUI

enum SearchMode {
    case fileSystem
    case image
    case localFont
}

@Observable class Search {
    
    private let fileSystemEngine = FileSystemSearchEngine()
    private let unsplashEngine = UnsplashSearchEngine()
    private let fontEngine = FontSearchEngine()
//    private let generativeAI = GenerativeAI()
    public var results = [SearchResult]()
    public var searchMode: SearchMode = .localFont
    
    private var activeEngine: Engine {
        switch searchMode {
        case .fileSystem:
            return fileSystemEngine
        case .image:
            return unsplashEngine
        case .localFont:
            return fontEngine
        }
    }
    
    init() {
        setupDelegates()
    }
    
    // MARK: - Methods
    private func setupDelegates() {
        fileSystemEngine.delegate = self
        unsplashEngine.delegate = self
        fontEngine.delegate = self
    }
    
    public func search(withQuery query: String, withActiveDirectory activeDirectory: String) async {
        await activeEngine.search(withQuery: query, inActiveDirectory: activeDirectory)
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
        self.results = results
    }
}


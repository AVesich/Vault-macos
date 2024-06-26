//
//  SearchModel.swift
//  Vault
//
//  Created by Austin Vesich on 5/18/24.
//

import SwiftUI

@Observable
class Search {
    
    private let fileSystemEngine = FileSystemSearchEngine()
    private let unsplashEngine = UnsplashSearchEngine()
    private let fontEngine = FontSearchEngine()
    private let githubEngine = GitHubSearchEngine()
    private let modeEngine = ModeSearchEngine()
//    private let generativeAI = GenerativeAI()
    private var queryString: String = "" {
        didSet {
            if let first = queryString.first,
               first == "/" {
                if searchMode != .modes {
                    searchMode = .modes
                }
                search(withActiveDirectory: "") // No directory needed in mode search
            }
        }
    }
    public var queryBinding: Binding<String> {
        Binding {
            return self.queryString
        } set: { newQuery in
            self.queryString = newQuery
        }
    }
    public var results = [SearchResult]()
    public var searchMode: SearchMode = .modes {
        didSet {
            if searchMode != .modes {
                queryString = ""
                results.removeAll()
            }
        }
    }
    
    private var activeEngine: Engine {
        switch searchMode {
        case .files:
            return fileSystemEngine
        case .images:
            return unsplashEngine
        case .fonts:
            return fontEngine
        case .gitHub:
            return githubEngine
        case .modes:
            return modeEngine
        default:
            return modeEngine
        }
    }
    
    public var activeEngineFilters: [SearchFilter] {
        activeEngine.searchFilters
    }
    
    init() {
        setupDelegates()
    }
    
    // MARK: - Methods
    private func setupDelegates() {
        fileSystemEngine.delegate = self
        unsplashEngine.delegate = self
        fontEngine.delegate = self
        githubEngine.delegate = self
        modeEngine.delegate = self
    }
    
    private func search(withActiveDirectory activeDirectory: String) {
        activeEngine.search(withQuery: queryString, inActiveDirectory: activeDirectory)
    }
    
    public func enterPressedSearch(withActiveDirectory activeDirectory: String) {
        if searchMode == .modes {
            if let result = results.first,
               let mode = result.searchMode {
                searchMode = mode
            }
        } else {
            search(withActiveDirectory: activeDirectory)
        }
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


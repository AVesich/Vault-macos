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
    private let modeEngine = ModeSearchEngine()
//    private let generativeAI = GenerativeAI()
    private var queryString: String = "" {
        didSet {
            if let first = queryString.first,
               first == "/" {
                if searchMode != .modes {
                    searchMode = .modes
                }
                Task {
                    await search(withActiveDirectory: "") // No directory needed in mode search
                }
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
    public var searchMode: SearchMode = .codeSnippets {
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
        case .modes:
            return modeEngine
        default:
            return modeEngine
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
        modeEngine.delegate = self
    }
    
    public func search(withActiveDirectory activeDirectory: String) async {
        await activeEngine.search(withQuery: queryString, inActiveDirectory: activeDirectory)
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


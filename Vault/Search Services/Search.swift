//
//  SearchModel.swift
//  Vault
//
//  Created by Austin Vesich on 5/18/24.
//

import SwiftUI

@Observable class Search {
    
    private let generativeAI = GenerativeAI()
    public var responses = [SearchResult]()
    
    public func search(withQuery query: String, withActiveDirectory activeDirectory: String) async {
        responses = await fileManagerSearch(withQuery: query, withActiveDirectory: activeDirectory)
    }
    
    private func fileManagerSearch(withQuery query: String, withActiveDirectory activeDirectory: String) async -> [SearchResult] {
        let searchEngine = FileSystemSearchEngine(activeDirectory: activeDirectory)
        return await searchEngine.search(withQuery: query)
    }
    
    private func aiSearch(withQuery query: String) async -> [SearchResult] {
        let aiResponse = await generativeAI.getResponse(to: query)
        if !aiResponse.isEmpty {
            let aiResponseData = SearchResult(text: aiResponse)
            return [aiResponseData]
        }
        return [SearchResult]()
    }
}

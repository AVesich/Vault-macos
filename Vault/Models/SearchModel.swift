//
//  SearchModel.swift
//  Vault
//
//  Created by Austin Vesich on 5/18/24.
//

import SwiftUI

@Observable class SearchModel {
    private let generativeAI = GenerativeAI()
    public var responses = [SearchResponse]()
    
    public func search(withQuery query: String) async {
        responses = await aiSearch(withQuery: query)
    }
    
    private func aiSearch(withQuery query: String) async -> [SearchResponse] {
        var aiResponseData = SearchResponse()
        let aiResponse = await generativeAI.getResponse(to: query)
        if !aiResponse.isEmpty {
            aiResponseData.text = aiResponse
            return [aiResponseData]
        }
        return [SearchResponse]()
    }
}

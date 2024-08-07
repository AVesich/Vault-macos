//
//  Engine.swift
//  Vault
//
//  The purpose of the engine is to act as a bridge between the global search system and each search mode's api.
//  The engine controls the api through filters, makes searches, and gives search results to a delegate (the global search system).
//  This abstracts api-specific behaviors from the GlobalSearch class, keeping it's focus on core search bar behaviors.
//
//  Created by Austin Vesich on 6/2/24.
//

import Foundation

protocol Engine {
    associatedtype EngineAPI: API
    
    var delegate: EngineDelegate? { get set }
    var API: EngineAPI! { get set }
    var searchFilters: [SearchFilter] { get }
    var specialAction: ((Int) -> ())? { get }
}

extension Engine {
    public mutating func clearResults() {
        API.resetQueryCache()
    }
    
    public mutating func search(withQuery query: String, inActiveDirectory activeDirectory: String) async {
        let nextPageResults = await API.getNextPage(forQuery: query)
        delegate?.engineRetrievedResults(newResults: nextPageResults)
    }
}

protocol EngineDelegate {
    func engineRetrievedResults(newResults: [any SearchResult])
    func engineRequestedResultsReset()
}

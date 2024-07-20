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
    var delegate: EngineDelegate? { get set }
    var API: (any API) { get set }
    var searchFilters: [SearchFilter] { get set }
    var autocompleteMethod: (() -> ())? { get set }
    
    func clearResults()
    func search(withQuery query: String, inActiveDirectory activeDirectory: String) async
}

extension Engine {
    public mutating func clearResults() {
        API.clearResults()
    }
    
    public mutating func search(withQuery query: String, inActiveDirectory activeDirectory: String) async {
        await API.updateResults(forQuery: query)
        delegate?.engineGotResults(results: API.getResults())
    }
}

protocol EngineDelegate {
    func engineGotResults(results: [any SearchResult])
}

//
//  Engine.swift
//  Vault
//
//  Created by Austin Vesich on 6/2/24.
//

import Foundation

protocol Engine {
    associatedtype ResultType
    
    var delegate: EngineDelegate? { get set }
    var searchResults: [ResultType] { get set }
    var searchFilters: [SearchFilter] { get }
    
    mutating func search(withQuery query: String, inActiveDirectory activeDirectory: String)
}

extension Engine {
    mutating func clearResults() {
        searchResults.removeAll()
    }
}

protocol EngineDelegate {
    func engineDidFindResults(results: [any SearchResult])
}

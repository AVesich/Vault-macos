//
//  Engine.swift
//  Vault
//
//  Created by Austin Vesich on 6/2/24.
//

import Foundation

protocol Engine {
    associatedtype ResultType
    
    var name: String { get }
    var delegate: EngineDelegate? { get set }
    var searchResults: [ResultType] { get set }
    var searchFilters: [SearchFilter] { get }
    var autocomplete: (() -> ())? { get }
    
    mutating func search(withQuery query: String, inActiveDirectory activeDirectory: String)
}

extension Engine {
    var RESULTS_PER_PAGE: Int {
        return PlistHelper.get(value: name+"_RESULTS_PER_PAGE", from: "EngineConfig")
    }
    var MAX_RESULTS: Int {
        return PlistHelper.get(value: name+"_MAX_RESULTS", from: "EngineConfig")
    }
        
    mutating func clearResults() {
        searchResults.removeAll()
    }
}

protocol EngineDelegate {
    func engineDidFindResults(results: [any SearchResult])
}

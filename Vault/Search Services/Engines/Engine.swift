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
    var searchMode: SearchMode { get }
    var searchFilters: [SearchFilter] { get }
    func search(withQuery query: String, inActiveDirectory activeDirectory: String)
}

protocol EngineDelegate {
    func engineDidFindResults(results: [any SearchResult])
}

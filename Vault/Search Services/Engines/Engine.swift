//
//  Engine.swift
//  Vault
//
//  Created by Austin Vesich on 6/2/24.
//

import Foundation

protocol Engine {
    var delegate: EngineDelegate? { get set }
    var searchResults: [SearchResult] { get set }
    var searchFilters: [SearchFilter] { get }
    func search(withQuery query: String, inActiveDirectory activeDirectory: String)
}

protocol EngineDelegate {
    func engineDidFindResults(results: [SearchResult])
}

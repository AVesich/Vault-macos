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
    func search(withQuery queryString: String, inActiveDirectory activeDirectory: String) async
}

protocol EngineDelegate {
    func engineDidFindResults(results: [SearchResult])
}

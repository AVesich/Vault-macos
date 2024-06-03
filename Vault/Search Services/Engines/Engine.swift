//
//  Engine.swift
//  Vault
//
//  Created by Austin Vesich on 6/2/24.
//

import Foundation

protocol Engine {
    var activeDirectory: String { get }
    
    func search(withQuery queryString: String) async -> [SearchResult]
}

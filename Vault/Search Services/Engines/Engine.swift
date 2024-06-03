//
//  Engine.swift
//  Vault
//
//  Created by Austin Vesich on 6/2/24.
//

import Foundation

protocol Engine {
    func search(withQuery queryString: String, inActiveDirectory activeDirectory: String) async -> [SearchResult]
}

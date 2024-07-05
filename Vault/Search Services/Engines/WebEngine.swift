//
//  WebEngine.swift
//  Vault
//
//  Created by Austin Vesich on 7/1/24.
//

import Foundation
import AppKit

class WebEngine: Engine {
    
    public var delegate: EngineDelegate?
    internal var searchResults = [WebResult]() {
        didSet {
            delegate?.engineDidFindResults(results: searchResults)
        }
    }
    public let searchFilters = [SearchFilter]()
    public var autocomplete: (() -> ())? { openTopResultInGoogle }
    
    // Nothing crazy for the search algorithm here. Mode count should never end up exceeding 20-30, so there should be no performance issues doing a simple search
    public func search(withQuery query: String, inActiveDirectory activeDirectory: String) {
        searchResults.removeAll()
        searchResults.append(WebResult(content: query))
    }
    
    private func openTopResultInGoogle() {
        if let first = searchResults.first,
           let url = URL(string: first.content) {
            NSWorkspace.shared.open(url)
        }
    }
}

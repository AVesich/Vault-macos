//
//  WebEngine.swift
//  Vault
//
//  Created by Austin Vesich on 7/1/24.
//

import Foundation
import AppKit

class WebEngine: Engine {
    
    internal let name = "Web"
    public var delegate: EngineDelegate?
    internal var searchResults = [WebResult]() {
        didSet {
            delegate?.engineGotResults(results: searchResults)
        }
    }
    public let searchFilters = [SearchFilter]()
    public var autocomplete: (() -> ())? { openTopResultInGoogle }
    private let GOOGLE_QUERY_URL = "https://www.google.com/search?q="
    
    // Nothing crazy for the search algorithm here. Mode count should never end up exceeding 20-30, so there should be no performance issues doing a simple search
    public func search(withQuery query: String, inActiveDirectory activeDirectory: String) {
        searchResults.removeAll()
        searchResults.append(WebResult(content: query))
        searchResults.append(WebResult(content: GOOGLE_QUERY_URL+query))
    }
    
    private func openTopResultInGoogle() {
        if let first = searchResults.first,
           let url = URLUtil.getURLToOpen(fromString: first.content) {
            NSWorkspace.shared.open(url)
        }
    }
}

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
    public var autocompleteMethod: (() -> ())?// { openTopResultInGoogle }
    internal let API: WebAPI! = WebAPI(configFileName: "WebAPIConfig", apiHasURL: true)
    public let searchFilters = [SearchFilter]()
    
    // Nothing crazy for the search algorithm here. Mode count should never end up exceeding 20-30, so there should be no performance issues doing a simple search
//    public func search(withQuery query: String, inActiveDirectory activeDirectory: String) {
//        searchResults.removeAll()
//        searchResults.append(WebResult(content: query))
//        searchResults.append(WebResult(content: GOOGLE_QUERY_URL+query))
//    }
    
//    private func openTopResultInGoogle() {
//        if let first = searchResults.first,
//           let url = URLUtil.getURLToOpen(fromString: first.content) {
//            NSWorkspace.shared.open(url)
//        }
//    }
}

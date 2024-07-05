//
//  WebEngine.swift
//  Vault
//
//  Created by Austin Vesich on 7/1/24.
//

class WebEngine: Engine {
    
    public var delegate: EngineDelegate?
    internal var searchResults = [WebResult]() {
        didSet {
            delegate?.engineDidFindResults(results: searchResults)
        }
    }
    public let searchFilters = [SearchFilter]()
    
    // Nothing crazy for the search algorithm here. Mode count should never end up exceeding 20-30, so there should be no performance issues doing a simple search
    func search(withQuery query: String, inActiveDirectory activeDirectory: String) {
        // TODO
    }
}

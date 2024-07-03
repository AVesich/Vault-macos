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
    
    func search(withQuery query: String, inActiveDirectory activeDirectory: String) {
        // TODO
    }
}

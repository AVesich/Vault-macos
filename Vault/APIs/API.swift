//
//  API.swift
//  Vault
//
//  Created by Austin Vesich on 7/12/24.
//

protocol API {
    var results: [any SearchResult] { get set }
    var prevQuery: String? { get set }
    var RESULTS_PER_PAGE: Int { get }
    // Pagination page tracking changes from API to API, so it isn't a field
    
    associatedtype APIPageMarker
    func updateResults(for query: String, start: APIPageMarker?, end: APIPageMarker?) // Appends results onto the result list, either a new page or a new query
    func getFirstPageResults(for query: String) -> [any SearchResult]
}

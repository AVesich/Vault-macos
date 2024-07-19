//
//  API.swift
//  Vault
//
//  Created by Austin Vesich on 7/12/24.
//

protocol API {
    var results: [any SearchResult] { get set }
    var prevQuery: String? { get set }
    var MAX_RESULTS: Int! { get set }
    var RESULTS_PER_PAGE: Int! { get set }
    // Pagination page tracking changes from API to API, so it isn't a field
    
    associatedtype APIPageMarker
    func getResults() -> [any SearchResult]
    func updateResults(for query: String, start: APIPageMarker?, end: APIPageMarker?) async // Appends results onto the result list, either a new page or a new query
    func getResultData(for query: String) async -> (results: [any SearchResult], nextPageInfo: NextPageInfo)
}

struct NextPageInfo {
    let nextPageCursor: String?
    let hasNextPage: Bool
    
    static let firstPageInfo = NextPageInfo(nextPageCursor: nil, hasNextPage: true)
}


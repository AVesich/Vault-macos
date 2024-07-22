//
//  WebAPI.swift
//  Vault
//
//  Created by Austin Vesich on 7/21/24.
//

final class WebAPI: API {
    
    // MARK: - Properties
    internal var apiConfig: APIConfig!
    internal var results = [any SearchResult]()
    internal var prevQuery: String?
    internal var nextPageInfo: NextPageInfo<Int> = NextPageInfo<Int>(nextPageCursor: nil, hasNextPage: false) // Web API will always return 1-2 results. No pagination.
    internal var isLoadingNewPage: Bool = false
    private let GOOGLE_QUERY = "https://www.google.com/search?q="
    
    // MARK: - Methods
    internal func postInitSetup() { }
    
    public func getResultData(for query: String) async -> APIResponse<Int> {
        var results = [WebResult]()
        
        if let firstURL = query.asOpenableURL() {
            results.append(WebResult(content: firstURL.absoluteString))
        }
        if query.isWebURL() { // Make google query the second result for real websites, otherwise only return query result with code above.
            results.append(WebResult(content: GOOGLE_QUERY+query))
        }
        
        return APIResponse<Int>(results: results, nextPageInfo: nextPageInfo) // Return the same next page info every time. No pagination should be used.
    }
}

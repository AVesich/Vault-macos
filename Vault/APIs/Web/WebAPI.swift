//
//  WebAPI.swift
//  Vault
//
//  Created by Austin Vesich on 7/21/24.
//

final class WebAPI: API {
    
    // MARK: - Properties
    internal var isReset: Bool = false
    internal var apiConfig: APIConfig!
    internal var results = [any SearchResult]()
    internal var prevQuery: String?
    internal var nextPageInfo: NextPageInfo<Int> = NextPageInfo<Int>(nextPageCursor: nil, hasNextPage: false) // Web API will always return 1-2 results. No pagination.
    internal var isLoadingNewPage: Bool = false
    internal var loadedPageCount: Int = 0
    private let GOOGLE_QUERY = "https://www.google.com/search?q="
    
    // MARK: - Methods
    internal func postInitSetup() { }
    
    public func getResultData(forQuery query: String) async -> APIResponse<Int> {
        var currentResults = [WebResult]()
        
        if let firstURL = query.asOpenableURL() {
            currentResults.append(WebResult(content: firstURL.absoluteString))
        }
        if query.isWebURL() { // Make google query the second result for real websites, otherwise only return query result with code above.
            currentResults.append(WebResult(content: GOOGLE_QUERY+query))
        }
        
        // Clear prior results before showing the new ones
//        self.results.removeAll()
//        dump(results)
        
        return APIResponse(results: currentResults, nextPageInfo: nextPageInfo) // Return the same next page info every time. No pagination should be used.
    }
}

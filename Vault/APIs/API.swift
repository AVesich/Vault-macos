//
//  API.swift
//  Vault
//
//  Created by Austin Vesich on 7/12/24.
//

protocol API {
    associatedtype PageCursorType
    
    var apiConfig: APIConfig! { get set }
    var results: [any SearchResult] { get set }
    var prevQuery: String? { get set }
    var nextPageInfo: NextPageInfo<PageCursorType> { get set }
    var isLoadingNewPage: Bool { get set }
    
    init()
    init(configFileName: String, apiHasURL: Bool, apiNeedsKey: Bool)
    
    func postInitSetup()
    func getResultData(for query: String) async -> APIResponse<PageCursorType>
}

extension API {
    init(configFileName: String, apiHasURL: Bool = false, apiNeedsKey: Bool = false) {
        self.init()
        apiConfig = APIConfig(configFileName: configFileName, apiHasURL: apiHasURL, apiNeedsKey: apiNeedsKey)
        if apiHasURL && apiConfig.API_URL==nil {
            fatalError("Failed to get ApiUrl from config file \(configFileName)")
        }
        postInitSetup()
    }
    
    public func getResults() -> [any SearchResult] {
        return results
    }
    
    public mutating func resetQueryCache() {
        results.removeAll()
        prevQuery = nil // Force next search to be new, not loading from a page
        nextPageInfo = NextPageInfo<PageCursorType>(nextPageCursor: nil, hasNextPage: true)
    }
    
    public mutating func updateResults(forQuery query: String) async {
        let newQuery = query != prevQuery
        if newQuery { // Make a new search, NOT a new page
//            nextPageInfo = NextPageInfo<PageCursorType>(nextPageCursor: nil, hasNextPage: true)
            resetQueryCache()
        }
//        prevQuery = query
        
        let resultData = await getResultData(for: query)
//        if newQuery {
//            results.removeAll()
//        }
        
        results.append(contentsOf: resultData.results)
        nextPageInfo = resultData.nextPageInfo
    }
}

struct NextPageInfo<CursorType> {
    let nextPageCursor: CursorType?
    let hasNextPage: Bool
}


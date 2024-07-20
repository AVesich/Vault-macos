//
//  API.swift
//  Vault
//
//  Created by Austin Vesich on 7/12/24.
//

protocol API {
    var apiConfig: APIConfig! { get set }
    var results: [any SearchResult] { get set }
    var prevQuery: String? { get set }
    var nextPageInfo: NextPageInfo { get set }
    var isLoadingNewPage: Bool { get set }
    
    init()
    init(configFileName: String, apiHasURL: Bool, apiNeedsKey: Bool)
    
    func getResultData(for query: String) async -> (results: [any SearchResult], nextPageInfo: NextPageInfo)
}

extension API {
    init(configFileName: String, apiHasURL: Bool, apiNeedsKey: Bool) {
        self.init()
        apiConfig = APIConfig(configFileName: configFileName, apiHasURL: apiHasURL, apiNeedsKey: apiNeedsKey)
        if apiHasURL && apiConfig.API_URL==nil {
            fatalError("Failed to get ApiUrl from config file \(configFileName)")
        }
            
    }
    
    public func getResults() -> [any SearchResult] {
        return results
    }
    
    public mutating func clearResults() {
        results.removeAll()
        prevQuery = nil // Force next search to be new, not loading from a page
    }
    
    public mutating func updateResults(forQuery query: String) async {
        let newQuery = query != prevQuery
        if newQuery { // Make a new search, NOT a new page
            nextPageInfo = .firstPageInfo
        }
        prevQuery = query
        
        let resultData = await getResultData(for: query)
        if newQuery {
            results.removeAll()
        }
        
        results.append(contentsOf: resultData.results)
        nextPageInfo = resultData.nextPageInfo
    }
}

struct NextPageInfo {
    let nextPageCursor: String?
    let hasNextPage: Bool
    
    static let firstPageInfo = NextPageInfo(nextPageCursor: nil, hasNextPage: true)
}


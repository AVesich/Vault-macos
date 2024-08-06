//
//  API.swift
//  Vault
//
//  Created by Austin Vesich on 7/12/24.
//

protocol API {
    associatedtype PageCursorType
    
    var isReset: Bool { get set }
    var apiConfig: APIConfig! { get set }
    var prevQuery: String? { get set }
    var nextPageInfo: NextPageInfo<PageCursorType> { get set }
    var isLoadingNewPage: Bool { get set }
    var loadedPageCount: Int { get set }
    
    init()
    init(configFileName: String, apiHasURL: Bool, apiNeedsKey: Bool)
    
    func postInitSetup()
    func getResultData(forQuery query: String) async -> APIResponse<PageCursorType>
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
        
    public mutating func resetQueryCache() {
        if isReset { // Multiple things can cause a reset, so this value is used to prevent 2x and 3x resets
            return
        }
        isReset = true
        prevQuery = nil // Force next search to be new, not loading from a page
        nextPageInfo = NextPageInfo<PageCursorType>(nextPageCursor: nil, hasNextPage: true)
    }
    
    public mutating func getNextPage(forQuery query: String) async -> [any SearchResult] {
        let newQuery = query != prevQuery
        if newQuery { // Make a new search, NOT a new page
            resetQueryCache()
        }
        prevQuery = query
        isReset = false // Set isReset to false once a meaningful change (prevQuery being cached) is made
        
        let resultData = await getResultData(forQuery: query)
        
        nextPageInfo = resultData.nextPageInfo
        return resultData.results
    }
}

struct NextPageInfo<CursorType> {
    let nextPageCursor: CursorType?
    let hasNextPage: Bool
}


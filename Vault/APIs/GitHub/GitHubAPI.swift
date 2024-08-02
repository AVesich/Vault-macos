//
//  GitHubAPI.swift
//  Vault
//
//  Created by Austin Vesich on 7/12/24.
//

import Apollo
import ApolloAPI
import GitHubAPI
import Foundation

final class GitHubAPI: API {

    // MARK: - Properties
    internal var isReset: Bool = false
    internal var apiConfig: APIConfig!
//    internal var results = [any SearchResult]()
    internal var prevQuery: String? = nil
    internal var nextPageInfo: NextPageInfo<String> = NextPageInfo<String>(nextPageCursor: nil, hasNextPage: true)
    internal var isLoadingNewPage: Bool = false
    internal var loadedPageCount: Int = 0
    private var currentMode: any GitHubAPIMode = .repoMode
    private var graphQLClient: ApolloClient!
    
    // MARK: - Initialization
    // Keys
    // avesich: "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"
    // rhit-vesichab: "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"
    internal func postInitSetup() {
        self.graphQLClient = getGraphQLClient(withEndpointURL: apiConfig.API_URL!, andAuthToken: apiConfig.API_KEY!)
    }
    
    private func getGraphQLClient(withEndpointURL endpointURL: URL, andAuthToken authToken: String) -> ApolloClient {
        let client = URLSessionClient()
        let cache = InMemoryNormalizedCache()
        let store = ApolloStore(cache: cache)
        let provider = AuthInterceptorProvider(client: client, store: store, authToken: authToken)
        let transport = RequestChainNetworkTransport(interceptorProvider: provider, endpointURL: endpointURL)
        
        return ApolloClient(networkTransport: transport, store: store)
    }
    
    // MARK: - Methods
    public func setActiveMode(to newMode: any GitHubAPIMode) {
        currentMode = newMode
    }
    
    internal func getResultData(forQuery query: String) async -> APIResponse<String> {
        var fetchedResults = [any SearchResult]()
        var fetchedNextPageInfo = NextPageInfo<String>(nextPageCursor: nil, hasNextPage: false)
        isLoadingNewPage = true
        defer {
            isLoadingNewPage = false
        }
        
        guard let graphQLClient, nextPageInfo.hasNextPage else {
            return APIResponse(results: fetchedResults, nextPageInfo: fetchedNextPageInfo)
        }
        
        do {
            let resultData = try await currentMode.fetch(withGraphQLClient: graphQLClient, query: query, numResults: apiConfig.RESULTS_PER_PAGE, nextCursor: nextPageInfo.nextPageCursor)
            loadedPageCount += 1
            
            fetchedResults = resultData.results
            let nextPageCursor = resultData.nextPageInfo.nextPageCursor
            var hasNextPage = resultData.nextPageInfo.hasNextPage
            if loadedPageCount >= apiConfig.MAX_PAGE_COUNT { // Override whether we have a next page - the result from fetch() is only based on whether github can supply more results
                hasNextPage = false
            }
            fetchedNextPageInfo = NextPageInfo<String>(nextPageCursor: nextPageCursor, hasNextPage: hasNextPage)
        } catch {
            print("Failed to fetch with error: \(error)")
        }
        return APIResponse(results: fetchedResults, nextPageInfo: fetchedNextPageInfo)
    }
}

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
    internal var apiConfig: APIConfig!
    internal var results = [any SearchResult]()
    internal var prevQuery: String? = nil
    internal var nextPageInfo: NextPageInfo = .firstPageInfo
    internal var isLoadingNewPage: Bool = false
    private var currentMode: any GitHubAPIMode = .repoMode
    private var graphQLClient: ApolloClient!
    
    // MARK: - Initialization
    init() {}
    init(configFileName: String, apiHasURL: Bool, apiNeedsKey: Bool) { // Re-declaration of default file name & key initializer from the protocol so that graphql client assignment can happen
        apiConfig = APIConfig(configFileName: configFileName, apiHasURL: apiHasURL, apiNeedsKey: apiNeedsKey)
        if apiHasURL && apiConfig.API_URL==nil {
            fatalError("Failed to get ApiUrl from config file \(configFileName)")
        }
        
        // avesich: "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"
        // rhit-vesichab: "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"
        self.graphQLClient = getGraphQLClient(withEndpointURL: apiConfig.API_URL!, andAuthToken: "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")
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
    
    internal func getResultData(for query: String) async -> (results: [any SearchResult], nextPageInfo: NextPageInfo) {
        var fetchedResults = [any SearchResult]()
        var fetchedNextPageInfo = NextPageInfo(nextPageCursor: nil, hasNextPage: false)
        isLoadingNewPage = true
        defer {
            isLoadingNewPage = false
        }
        
        guard let graphQLClient, (results.isEmpty || nextPageInfo.hasNextPage) else {
            return (fetchedResults, fetchedNextPageInfo)
        }
        
        do {
            let resultData = try await currentMode.fetch(withGraphQLClient: graphQLClient, query: query, numResults: apiConfig.RESULTS_PER_PAGE, nextCursor: nextPageInfo.nextPageCursor)
            fetchedResults = resultData.results
            fetchedNextPageInfo = resultData.nextPageInfo
        } catch {
            print("Failed to fetch with error: \(error)")
        }
        return (fetchedResults, fetchedNextPageInfo)
    }
}

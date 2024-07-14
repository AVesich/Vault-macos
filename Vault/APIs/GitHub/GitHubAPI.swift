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
    internal var MAX_RESULTS: Int!
    internal var RESULTS_PER_PAGE: Int!
    private var currentMode: any GitHubAPIMode = .repoMode
    internal var results = [any SearchResult]()
    internal var prevQuery: String?
    private var graphQLClient: ApolloClient!
    private var nextPageKey: String = ""
    
    // MARK: - Initialization
    init(MAX_RESULTS: Int, RESULTS_PER_PAGE: Int) {
        let config = APIConfig(configFileName: "GitHubAPIConfig")
        guard let apiURL = config.apiURL else {
            fatalError("Failed to get ApiUrl from Github API config file")
        }
        
        self.MAX_RESULTS = MAX_RESULTS
        self.RESULTS_PER_PAGE = RESULTS_PER_PAGE

        self.graphQLClient = getGraphQLClient(withEndpointURL: apiURL, andAuthToken: "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")
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
    public func getResults() -> [any SearchResult] {
        return results
    }
    
    public func updateResults(for query: String, start: String?, end: String?) { // No end needed, github wants start key & number to load from there
        Task {
            if query != prevQuery { // Make a new search, NOT a new page
                results = await getFirstPageResults(for: query)
                prevQuery = query
                return
            }
            
            if let start {
                results.append(contentsOf: getNextPageOfResults(startingAt: start))
                prevQuery = query
            }
        }
    }
    
    public func setActiveMode(to newMode: any GitHubAPIMode) {
        currentMode = newMode
    }
    
    internal func getFirstPageResults(for query: String) async -> [any SearchResult] {
        guard let graphQLClient else {
            return []
        }
        
        var results = [any SearchResult]()
        do {
            results = try await currentMode.fetch(withGraphQLClient: graphQLClient, query: query, numResults: RESULTS_PER_PAGE)
        } catch {
            print("Failed to fetch with error: \(error)")
        }
        
        dump(results.first)
        return results
    }
    
    private func getResponseDataAsResults() {
        
    }
    
    internal func getNextPageOfResults(startingAt start: String) -> [any SearchResult] {
        guard let graphQLClient, let prevQuery, results.count < MAX_RESULTS else {
            return []
        }
        
        let apiResults = graphQLClient.fetch(query: GitHubRepoQuery(query: prevQuery, numResults: RESULTS_PER_PAGE, afterCursor: GraphQLNullable<String>(stringLiteral: nextPageKey)))
        
        return []
    }
}

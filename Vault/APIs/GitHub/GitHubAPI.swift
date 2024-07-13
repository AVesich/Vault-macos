//
//  GitHubAPI.swift
//  Vault
//
//  Created by Austin Vesich on 7/12/24.
//

import Apollo
import GitHubAPI

final class GitHubAPI: API {
    // MARK: - Properties
    public var results = [any SearchResult]()
    internal var prevQuery: String?
    internal let RESULTS_PER_PAGE = 30
    internal let MAX_RESULTS = 300
    private let graphQLClient: ApolloClient?
    private var nextPageKey: String = ""
    
    // MARK: - Initialization
    init() {
        let config = APIConfig(configFileName: "Config")
        guard let apiURL = config.apiURL else {
            fatalError("Failed to get ApiUrl from Github API config file")
        }
        graphQLClient = ApolloClient(url: apiURL)
    }
    
    // MARK: - Methods
    public func updateResults(for query: String, start: String?, end: String?) { // No end needed, github wants start key & number to load from there
        if query != prevQuery { // Make a new search, NOT a new page
            results = getFirstPageResults(for: query)
            return
        }
        
        guard let start else {
            return
        }
        results.append(contentsOf: getNextPageOfResults(startingAt: start))
        
        prevQuery = query
    }
    
    internal func getFirstPageResults(for query: String) -> [any SearchResult] {
        guard let graphQLClient else {
            return []
        }
        
        let apiResults = graphQLClient.fetch(query: GitHubRepoQuery(query: query, numResults: RESULTS_PER_PAGE, afterCursor: GraphQLNullable<String>(nilLiteral: ()))) { response in
            switch response {
            case .success(let graphQLResponse):
                let data = graphQLResponse.data
                print("Successful request! Response: \(graphQLResponse)")
                print("Data: \(data)")
            case .failure(let error):
                print("Failed request! Error: \(error)")
            }
        }
        
        return []
    }
    
    internal func getNextPageOfResults(startingAt start: String) -> [any SearchResult] {
        guard let graphQLClient, let prevQuery, results.count < MAX_RESULTS else {
            return []
        }
        
        let apiResults = graphQLClient.fetch(query: GitHubRepoQuery(query: prevQuery, numResults: RESULTS_PER_PAGE, afterCursor: GraphQLNullable<String>(stringLiteral: nextPageKey)))
        
        return []
    }
}

//
//  GitHubAPIModes.swift
//  Vault
//
//  Created by Austin Vesich on 7/13/24.
//

import GitHubAPI
import Apollo
import ApolloAPI

// MARK: - Mode Protocol
protocol GitHubAPIMode {
    associatedtype Query: GraphQLQuery
    
    func fetch(withGraphQLClient client: ApolloClient, query: String, numResults: Int) async throws  -> [any SearchResult]
    func getQueryWithParams(_ query: String, numResults: Int, start: String?) -> Query
    func getResponseDataAsResults<ResponseData>(_ responseData: ResponseData?) -> [any SearchResult]
}

// MARK: - Mode Implementations
final class GitHubAPIRepoMode: GitHubAPIMode {
    typealias Repository = GitHubRepoQuery.Data.Search.Repo.Repo.AsRepository
        
    public func fetch(withGraphQLClient client: ApolloClient, query: String, numResults: Int) async throws -> [any SearchResult] {
        let query = getQueryWithParams(query, numResults: numResults)
        let response = try await client.fetchAsync(query: query)
        return getResponseDataAsResults(response.data)
    }
    
    internal func getQueryWithParams(_ query: String, numResults: Int, start: String? = nil) -> GitHubRepoQuery {
        var afterCursor = GraphQLNullable<String>(nilLiteral: ())
        if let start {
            afterCursor = GraphQLNullable<String>(stringLiteral: start)
        }
        return GitHubRepoQuery(query: query,
                               numResults: numResults,
                               afterCursor: afterCursor)
    }
    
    internal func getResponseDataAsResults<ResponseData>(_ responseData: ResponseData?) -> [any SearchResult] {
        guard let responseData = responseData as? GitHubRepoQuery.Data else {
            return []
        }
        let repos: [Repository] = responseData.search.repos?.compactMap { $0?.repo?.asRepository } ?? [Repository]()
        return repos.map { GitHubRepoResult(content: GitHubRepoSearchResult(name: $0.name,
                                                                            html_url: $0.url,
                                                                            owner: GitHubUser(login: $0.owner.login,
                                                                                              avatar_url: $0.owner.avatarUrl))) }
    }
}

// MARK: - Mode Extension + Variables
extension GitHubAPIMode where Self == GitHubAPIRepoMode {
    static var repoMode: GitHubAPIRepoMode {
        return GitHubAPIRepoMode()
    }
}

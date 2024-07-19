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
    
    func fetch(withGraphQLClient client: ApolloClient, query: String, numResults: Int, nextCursor: String?) async throws  -> (results: [any SearchResult], nextPageInfo: NextPageInfo)
    func getQueryWithParams(_ query: String, numResults: Int, startCursor: String?) -> Query
    func getResponseResults<ResponseData>(fromData responseData: ResponseData?) -> [any SearchResult]
    func getResponseNextPageInfo<ResponseData>(fromData responseData: ResponseData?) -> NextPageInfo
}

// MARK: - Mode Implementations
final class GitHubAPIRepoMode: GitHubAPIMode {
    typealias Repository = GitHubRepoQuery.Data.Search.Repo.Repo.AsRepository
        
    public func fetch(withGraphQLClient client: ApolloClient, query: String, numResults: Int, nextCursor: String?) async throws -> (results: [any SearchResult], nextPageInfo: NextPageInfo) {
        let query = getQueryWithParams(query, numResults: numResults, startCursor: nextCursor)
        let response = try await client.fetchAsync(query: query)
        return (getResponseResults(fromData: response.data), getResponseNextPageInfo(fromData: response.data))
    }
    
    internal func getQueryWithParams(_ query: String, numResults: Int, startCursor: String? = nil) -> GitHubRepoQuery {
        var afterCursor = GraphQLNullable<String>(nilLiteral: ())
        if let startCursor {
            afterCursor = GraphQLNullable<String>(stringLiteral: startCursor)
        }
        return GitHubRepoQuery(query: query,
                               numResults: numResults,
                               afterCursor: afterCursor)
    }
    
    internal func getResponseResults<ResponseData>(fromData responseData: ResponseData?) -> [any SearchResult] {
        guard let responseData = responseData as? GitHubRepoQuery.Data else {
            return []
        }
        let repos: [Repository] = responseData.search.repos?.compactMap { $0?.repo?.asRepository } ?? [Repository]()
        return repos.map { GitHubRepoResult(content: GitHubRepoSearchResult(name: $0.name,
                                                                            html_url: $0.url,
                                                                            owner: GitHubUser(login: $0.owner.login,
                                                                                              avatar_url: $0.owner.avatarUrl))) }
    }
    
    internal func getResponseNextPageInfo<ResponseData>(fromData responseData: ResponseData?) -> NextPageInfo {
        guard let responseData = responseData as? GitHubRepoQuery.Data else {
            return NextPageInfo(nextPageCursor: nil, 
                                         hasNextPage: false)
        }
        let pageInfo = responseData.search.pageInfo
        return NextPageInfo(nextPageCursor: pageInfo.endCursor,
                                     hasNextPage: (pageInfo.endCursor == nil) ? false : pageInfo.hasNextPage)
    }

}

final class GitHubAPIUserMode: GitHubAPIMode {
    typealias User = GitHubUserQuery.Data.Search.User.User.AsUser
        
    public func fetch(withGraphQLClient client: ApolloClient, query: String, numResults: Int, nextCursor: String?) async throws -> (results: [any SearchResult], nextPageInfo: NextPageInfo) {
        let query = getQueryWithParams(query, numResults: numResults, startCursor: nextCursor)
        let response = try await client.fetchAsync(query: query)
        return (getResponseResults(fromData: response.data), getResponseNextPageInfo(fromData: response.data))
    }
    
    internal func getQueryWithParams(_ query: String, numResults: Int, startCursor: String? = nil) -> GitHubUserQuery {
        var afterCursor = GraphQLNullable<String>(nilLiteral: ())
        if let startCursor {
            afterCursor = GraphQLNullable<String>(stringLiteral: startCursor)
        }
        return GitHubUserQuery(query: query,
                               numResults: numResults,
                               afterCursor: afterCursor)
    }
    
    internal func getResponseResults<ResponseData>(fromData responseData: ResponseData?) -> [any SearchResult] {
        guard let responseData = responseData as? GitHubUserQuery.Data else {
            return []
        }
        let repos: [User] = responseData.search.users?.compactMap { $0?.user?.asUser } ?? [User]()
        return repos.map { GitHubUserResult(content: GitHubUserSearchResult(login: $0.login,
                                                                            avatar_url: $0.avatarUrl,
                                                                            html_url: $0.url)) }
    }
    
    internal func getResponseNextPageInfo<ResponseData>(fromData responseData: ResponseData?) -> NextPageInfo {
        guard let responseData = responseData as? GitHubUserQuery.Data else {
            return NextPageInfo(nextPageCursor: nil,
                                         hasNextPage: false)
        }
        let pageInfo = responseData.search.pageInfo
        return NextPageInfo(nextPageCursor: pageInfo.endCursor,
                                     hasNextPage: (pageInfo.endCursor == nil) ? false : pageInfo.hasNextPage)
    }

}

// MARK: - Mode + Variables
extension GitHubAPIMode where Self == GitHubAPIRepoMode {
    static var repoMode: GitHubAPIRepoMode {
        return GitHubAPIRepoMode()
    }
}

extension GitHubAPIMode where Self == GitHubAPIUserMode {
    static var userMode: GitHubAPIUserMode {
        return GitHubAPIUserMode()
    }
}


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
    
    func fetch(withGraphQLClient client: ApolloClient, query: String, numResults: Int, nextCursor: String?) async throws  -> (results: [any SearchResult], nextPageInfo: NextPageInfo<String>)
    func getQueryWithParams(_ query: String, numResults: Int, startCursor: String?) -> Query
    func getResponseResults<ResponseData>(fromData responseData: ResponseData?) -> [any SearchResult]
    func getResponseNextPageInfo<ResponseData>(fromData responseData: ResponseData?) -> NextPageInfo<String>
}

// MARK: - Mode Implementations
final class GitHubAPIRepoMode: GitHubAPIMode {
    typealias Repository = GitHubRepoQuery.Data.Search.Repo.Repo.AsRepository
        
    public func fetch(withGraphQLClient client: ApolloClient, query: String, numResults: Int, nextCursor: String?) async throws -> (results: [any SearchResult], nextPageInfo: NextPageInfo<String>) {
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
        return repos.map { GitHubRepoResult(content: GitHubRepoAPIResult(name: $0.name,
                                                                         htmlURLString: $0.url,
                                                                         ownerUsername: $0.owner.login,
                                                                         ownerAvatarURLString: $0.owner.avatarUrl)) }
    }
    
    internal func getResponseNextPageInfo<ResponseData>(fromData responseData: ResponseData?) -> NextPageInfo<String> {
        guard let responseData = responseData as? GitHubRepoQuery.Data else {
            return NextPageInfo<String>(nextPageCursor: nil,
                                        hasNextPage: false)
        }
        let pageInfo = responseData.search.pageInfo
        return NextPageInfo(nextPageCursor: pageInfo.endCursor,
                            hasNextPage: (pageInfo.endCursor == nil) ? false : pageInfo.hasNextPage)
    }

}

final class GitHubAPIUserMode: GitHubAPIMode {
    typealias User = GitHubUserQuery.Data.Search.User.User.AsUser
        
    public func fetch(withGraphQLClient client: ApolloClient, query: String, numResults: Int, nextCursor: String?) async throws -> (results: [any SearchResult], nextPageInfo: NextPageInfo<String>) {
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
        let users: [User] = responseData.search.users?.compactMap { $0?.user?.asUser } ?? [User]()
        return users.map { GitHubUserResult(content: GitHubUserAPIResult(login: $0.login,
                                                                            avatarURLString: $0.avatarUrl,
                                                                            htmlURLString: $0.url)) }
    }
    
    internal func getResponseNextPageInfo<ResponseData>(fromData responseData: ResponseData?) -> NextPageInfo<String> {
        guard let responseData = responseData as? GitHubUserQuery.Data else {
            return NextPageInfo(nextPageCursor: nil,
                                         hasNextPage: false)
        }
        let pageInfo = responseData.search.pageInfo
        return NextPageInfo(nextPageCursor: pageInfo.endCursor,
                            hasNextPage: (pageInfo.endCursor == nil) ? false : pageInfo.hasNextPage)
    }

}

final class GitHubAPIPullRequestMode: GitHubAPIMode {
    typealias PullRequest = GitHubPRQuery.Data.Viewer.PullRequests.PullRequest.PullRequests
        
    public func fetch(withGraphQLClient client: ApolloClient, query: String, numResults: Int, nextCursor: String?) async throws -> (results: [any SearchResult], nextPageInfo: NextPageInfo<String>) {
        let query = getQueryWithParams(query, numResults: numResults, startCursor: nextCursor)
        let response = try await client.fetchAsync(query: query)
        return (getResponseResults(fromData: response.data), getResponseNextPageInfo(fromData: response.data))
    }
    
    internal func getQueryWithParams(_ query: String, numResults: Int, startCursor: String? = nil) -> GitHubPRQuery {
        var afterCursor = GraphQLNullable<String>(nilLiteral: ())
        if let startCursor {
            afterCursor = GraphQLNullable<String>(stringLiteral: startCursor)
        }
        return GitHubPRQuery(numResults: numResults,
                             afterCursor: afterCursor)
    }
    
    internal func getResponseResults<ResponseData>(fromData responseData: ResponseData?) -> [any SearchResult] {
        guard let responseData = responseData as? GitHubPRQuery.Data else {
            return []
        }
        let repos: [PullRequest] = responseData.viewer.pullRequests.pullRequests?.compactMap { $0?.pullRequests } ?? [PullRequest]()
        return repos.map { GitHubPullRequestResult(content: GitHubPullRequestAPIResult(authorUsername: $0.author?.login,
                                                                                       authorAvatarURLString: $0.author?.avatarUrl,
                                                                                       closed: $0.closed,
                                                                                       merged: $0.merged,
                                                                                       title: $0.title,
                                                                                       htmlURLString: $0.url,
                                                                                       baseRefName: $0.baseRefName,
                                                                                       headRefName: $0.headRefName)) }
    }
    
    internal func getResponseNextPageInfo<ResponseData>(fromData responseData: ResponseData?) -> NextPageInfo<String> {
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

extension GitHubAPIMode where Self == GitHubAPIPullRequestMode {
    static var pullRequestMode: GitHubAPIPullRequestMode {
        return GitHubAPIPullRequestMode()
    }
}

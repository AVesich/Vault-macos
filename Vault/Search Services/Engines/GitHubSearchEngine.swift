//
//  GithubSearchEngine.swift
//  Vault
//
//  Created by Austin Vesich on 6/24/24.
//

import Foundation
import SwiftUI

// MARK: - Engine
class GitHubSearchEngine: Engine {
    // MARK: - Properties
    public var searchResults: [GitHubRepoResult] = [GitHubRepoResult]() {
        didSet {
            delegate?.engineDidFindResults(results: searchResults)
        }
    }
    internal var delegate: EngineDelegate?
    private let API_URL = "https://api.github.com"
    private let RESULTS_PER_PAGE = 15
    
    // MARK: - Search Filters
    private var activeFilter: GitHubFilter = GitHubFilter<GitHubRepoSearchWrapper, GitHubRepoSearchResult, GitHubRepoResult>(urlSuffix: "")
    public var searchFilters: [SearchFilter] {
        [SearchFilter(name: "Repositories",
                      iconName: "externaldrive.connected.to.line.below.fill",
                      selectAction: { [weak self] in self?.activeFilter = GitHubFilter<GitHubRepoSearchWrapper, GitHubRepoSearchResult, GitHubRepoResult>(urlSuffix: "") },
                      deselectAction: nil),
         SearchFilter(name: "Users",
                      iconName: "person.fill",
                      selectAction: { [weak self] in self?.activeFilter = GitHubFilter<GitHubUserSearchWrapper, GitHubUserSearchResult, GitHubUserResult>(urlSuffix: "") },
                      deselectAction: nil),
         SearchFilter(name: "My Pull Requests",
                      iconName: "arrow.trianglehead.pull",
                      selectAction: { [weak self] in self?.activeFilter = GitHubFilter<GitHubRepoSearchWrapper, GitHubRepoSearchResult, GitHubRepoResult>(urlSuffix: "") },
                      deselectAction: nil)]
    }

    
    // MARK: - Methods
    public func search(withQuery query: String, inActiveDirectory activeDirectory: String) {
        Task {
            await searchRepositories(withQuery: query)
        }
    }
    
    private func searchRepositories(withQuery query: String) async {
        guard let searchRequest = getURLRequest(withQuery: query) else {
            return
        }
        if let (data, _) = try? await URLSession.shared.data(for: searchRequest) {
            if let result = activeFilter.decoder.decodeValueFromData(data) {
                searchResults = result.items.map {
                    return activeFilter.searchResult(withResultContent: $0)
                }
            }
        }
    }
        
    private func getURLRequest(withQuery query: String) -> URLRequest? {
        let params: [String: String] = [
            "q" : query,
            "per_page": "\(RESULTS_PER_PAGE)"
        ]
        return APIJSONHelpers.getURLRequest(withURLString: API_URL+activeFilter.urlSuffix+"?",
                                            andParams: params)
    }
}

// MARK: - Filters
//struct GitHubFilter<DecodedType: GitHubResultWrapper, EndDecodingType: Codable, ResultType: SearchResult> where EndDecodingType == ResultType.SearchContent {
//    let urlSuffix: String
//    let decoder = APIDecoder<DecodedType>()
//    
//    func searchResult(withResultContent resultContent: Codable) -> ResultType {
//        let content = resultContent as! EndDecodingType
//        return ResultType(content: content)
//    }
//}



//protocol GitHubFilter {
//    associatedtype DecodedType: some GitHubResultWrapper
//    
//    var urlSuffix: String { get }
//    var decoder: APIDecoder<DecodedType> { get }
//    
//    func searchResult(withResultContent resultContent: Codable) -> any SearchResult
//}
//
//struct RepoFilter: GitHubFilter {
//    typealias DecodedType = GitHubRepoSearchWrapper
//    
//    let urlSuffix = "/search/repositories"
//    let decoder = APIDecoder<GitHubRepoSearchWrapper>()
//    
//    func searchResult(withResultContent resultContent: Codable) -> any SearchResult {
//        let content = resultContent as! GitHubRepoSearchResult
//        return GitHubRepoResult(content: content)
//    }
//}
//
//struct UserFilter: GitHubFilter {
//    typealias DecodedType = GitHubUserSearchWrapper
//    
//    let urlSuffix = "/search/users"
//    let decoder = APIDecoder<GitHubUserSearchWrapper>()
//    
//    func searchResult(withResultContent resultContent: Codable) -> any SearchResult {
//        let content = resultContent as! GitHubUserSearchResult
//        return GitHubUserResult(content: content)
//    }
//}

//enum GitHubFilterEnum {
//    static let repoFilter = RepoFilter()
//    static let userFilter = UserFilter()
//}

//struct GitHubFilter<T: Codable, V: SearchResult> {
//    let urlSuffix: String
//    let decoder = APIDecoder<T>()
//    let resultType = V.self
//}

//extension GitHubFilter where Self == RepoFilter {
//    static var repoFilter: Self { Self() }
//}
//
//extension GitHubFilter where Self == UserFilter {
//    static var userFilter: Self { Self() }
//}

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
    enum FilterMode {
        case repos
        case users
        case prs
        
        var urlSuffix: String {
            switch self {
            case .repos:
                return "/search/repositories"
            case .users:
                return "/search/users"
            case .prs:
                return "/search/repositories"
            }
        }
    }
    
    // MARK: - Properties
    internal let name = "GitHub"
    public var delegate: EngineDelegate?
    internal var searchResults = [any SearchResult]() {
        didSet {
            delegate?.engineDidFindResults(results: searchResults)
        }
    }
    public var autocomplete: (() -> ())? = nil
    private let API_URL = "https://api.github.com"
    private let RESULTS_PER_PAGE = 15
    private var api: GitHubAPI!
    
    // MARK: - Search Filters
    private var activeFilter: FilterMode = .repos
    public var searchFilters: [SearchFilter] {
        [SearchFilter(name: "Repositories",
                      iconName: "externaldrive.connected.to.line.below.fill",
                      selectAction: { [weak self] in self?.activeFilter = .repos },
                      deselectAction: nil),
         SearchFilter(name: "Users",
                      iconName: "person.fill",
                      selectAction: { [weak self] in self?.activeFilter = .users},
                      deselectAction: nil),
         SearchFilter(name: "My Pull Requests",
                      iconName: "arrow.trianglehead.pull",
                      selectAction: { [weak self] in self?.activeFilter = .prs },
                      deselectAction: nil)]
    }
    // TODO: This code sucks replace it ALL with a protocol/struct. 4 hours on this issue is too much, writing it the bad way for now
    private var activeSearchMethod: (String) async -> () {
        switch activeFilter {
        case .repos:
            return searchRepositories
        case .users:
            return searchUsers
        case .prs:
            return searchRepositories
        }
    }
    
    init() {
        api = GitHubAPI(MAX_RESULTS: self.MAX_RESULTS,
                        RESULTS_PER_PAGE: self.RESULTS_PER_PAGE)
    }

    // MARK: - Methods
    public func search(withQuery query: String, inActiveDirectory activeDirectory: String) {
//        Task {
//            await activeSearchMethod(query)
//        }
        api.updateResults(for: query, start: nil, end: nil)
    }
    
    private func searchRepositories(withQuery query: String) async {
        guard let searchRequest = getURLRequest(withQuery: query) else {
            return
        }
        if let (data, _) = try? await URLSession.shared.data(for: searchRequest) {
            if let result = APIDecoder<GitHubRepoSearchWrapper>().decodeValueFromData(data) {
                searchResults = result.items.map {
                    return GitHubRepoResult(content: $0)
                }
            }
        }
    }
    
    private func searchUsers(withQuery query: String) async {
        guard let searchRequest = getURLRequest(withQuery: query) else {
            return
        }
        if let (data, _) = try? await URLSession.shared.data(for: searchRequest) {
            if let result = APIDecoder<GitHubUserSearchWrapper>().decodeValueFromData(data) {
                searchResults = result.items.map {
                    return GitHubUserResult(content: $0)
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

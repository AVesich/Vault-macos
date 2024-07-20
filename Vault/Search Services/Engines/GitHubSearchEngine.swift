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
            delegate?.engineGotResults(results: searchResults)
        }
    }
    public var autocomplete: (() -> ())? = nil
//    private let API_URL = "https://api.github.com"
//    private let RESULTS_PER_PAGE = 15
    private var api: GitHubAPI!
    
    // MARK: - Search Filters
//    private var activeFilter: FilterMode = .repos
    public var searchFilters: [SearchFilter] {
        [SearchFilter(name: "Repositories",
                      iconName: "externaldrive.connected.to.line.below.fill",
                      selectAction: { [weak self] in self?.api.setActiveMode(to: .repoMode) },
                      deselectAction: nil),
         SearchFilter(name: "Users",
                      iconName: "person.fill",
                      selectAction: { [weak self] in self?.api.setActiveMode(to: .userMode) },
                      deselectAction: nil),
         SearchFilter(name: "Pull Requests",
                      iconName: "arrow.trianglehead.pull",
                      selectAction: { [weak self] in self?.api.setActiveMode(to: .pullRequestMode) },
                      deselectAction: nil)]
    }
    
    init() {
        // Result constants are provided by the Engine default values extension; they are not shown in this file
        api = GitHubAPI(MAX_RESULTS: self.MAX_RESULTS,
                        RESULTS_PER_PAGE: self.RESULTS_PER_PAGE)
    }

    // MARK: - Methods
    public func search(withQuery query: String, inActiveDirectory activeDirectory: String) {
        Task {
            await api.updateResults(for: query, start: nil, end: nil)
            searchResults = api.results
        }
    }
}

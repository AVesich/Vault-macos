//
//  GithubSearchEngine.swift
//  Vault
//
//  Created by Austin Vesich on 6/24/24.
//

import Foundation
import SwiftUI

// MARK: - Engine
final class GitHubSearchEngine: Engine {
    // MARK: - Properties
    public var delegate: EngineDelegate?
    internal var API: GitHubAPI! = GitHubAPI(configFileName: "GitHubAPIConfig", apiHasURL: false, apiNeedsKey: false)
    public var searchFilters: [SearchFilter] {
        [SearchFilter(name: "Repositories",
                      iconName: "externaldrive.connected.to.line.below.fill",
                      selectAction: { [weak self] in self?.API.setActiveMode(to: .repoMode) },
                      deselectAction: nil),
         SearchFilter(name: "Users",
                      iconName: "person.fill",
                      selectAction: { [weak self] in self?.API.setActiveMode(to: .userMode) },
                      deselectAction: nil),
         SearchFilter(name: "Pull Requests",
                      iconName: "arrow.trianglehead.pull",
                      selectAction: { [weak self] in self?.API.setActiveMode(to: .pullRequestMode) },
                      deselectAction: nil)]
    }
    internal let autocompleteMethod: (() -> ())? = nil
}

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
    internal var API: GitHubAPI! = GitHubAPI(configFileName: "GitHubAPIConfig", apiHasURL: true, apiNeedsKey: true)
    public var searchFilters: [SearchFilter] {
        [SearchFilter(name: "Repositories",
                      iconName: "externaldrive.connected.to.line.below.fill",
                      selectAction: { [weak self] in self?.changeAPIMode(to: .repoMode) },
                      deselectAction: nil),
         SearchFilter(name: "Users",
                      iconName: "person.fill",
                      selectAction: { [weak self] in self?.changeAPIMode(to: .userMode) },
                      deselectAction: nil),
         SearchFilter(name: "Pull Requests",
                      iconName: "arrow.trianglehead.pull",
                      selectAction: { [weak self] in self?.changeAPIMode(to: .pullRequestMode) },
                      deselectAction: nil)]
    }
    internal let autocompleteMethod: (() -> ())? = nil
    
    private func changeAPIMode(to newMode: any GitHubAPIMode) {
        API.setActiveMode(to: newMode)
        delegate?.engineRequestedResultsReset()
    }
}

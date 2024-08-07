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
    public var specialAction: ((Int) -> ())? { openGitHubItem }

    private func changeAPIMode(to newMode: any GitHubAPIMode) {
        API.setActiveMode(to: newMode)
        API.resetQueryCache() // Prevent query staying the same and changing filters from thinking NEW pages should be loaded
        delegate?.engineRequestedResultsReset()
    }
    
    private func openGitHubItem(withIndex index: Int) {
        if let delegate = delegate as? GitHubEngineDelegate {
            delegate.openGitHubItem(withIndex: index)
        }
    }
}

protocol GitHubEngineDelegate: EngineDelegate {
    func openGitHubItem(withIndex: Int)
}

extension GlobalSearch: GitHubEngineDelegate {
    func openGitHubItem(withIndex index: Int) {
        guard index < foundResults.count else {
            return
        }
        
        var url: URL?
        if let result = foundResults[index] as? GitHubRepoResult {
            url = URL(string: result.content.htmlURLString)
        } else if let result = foundResults[index] as? GitHubUserResult {
            url = URL(string: result.content.htmlURLString)
        } else if let result = foundResults[index] as? GitHubPullRequestResult {
            url = URL(string: result.content.htmlURLString)
        }
        
        if let url {
            NSWorkspace.shared.open(url)
        }
    }
}

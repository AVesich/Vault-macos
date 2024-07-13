//
//  GitHubUserSearchResult.swift
//  Vault
//
//  Created by Austin Vesich on 6/30/24.
//

struct GitHubUserSearchWrapper: GitHubResultWrapper {
    let total_count: Int
    let incomplete_results: Bool
    let items: [GitHubUserSearchResult]
}

struct GitHubUserSearchResult: Codable {
    let id: Int
    let login: String
    let avatar_url: String
    let html_url: String
}

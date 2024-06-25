//
//  GitHubRepoSearchResult.swift
//  Vault
//
//  Created by Austin Vesich on 6/24/24.
//

struct GitHubRepoSearchWrapper: Codable {
    let total_count: Int
    let incomplete_results: Bool
    let items: [GitHubRepoSearchResult]
}

struct GitHubRepoSearchResult: Codable {
    let id: Int
    let name: String
    let owner: GitHubUser
    let html_url: String
}

struct GitHubUser: Codable {
    let login: String
    let avatar_url: String
}

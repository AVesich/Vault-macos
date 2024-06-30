//
//  GitHubRepoSearchResult.swift
//  Vault
//
//  Created by Austin Vesich on 6/24/24.
//

protocol GitHubResultWrapper: Codable {
    associatedtype GithubSearchResult
    
    var total_count: Int { get }
    var incomplete_results: Bool { get }
    var items: [GithubSearchResult] { get }
}

struct GitHubRepoSearchWrapper: GitHubResultWrapper {
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

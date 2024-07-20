//
//  GitHubUserSearchResult.swift
//  Vault
//
//  Created by Austin Vesich on 6/30/24.
//

struct GitHubUserAPIResult: Codable {
    let login: String
    let avatarURLString: String
    let htmlURLString: String
}

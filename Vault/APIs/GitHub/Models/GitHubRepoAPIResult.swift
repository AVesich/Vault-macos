//
//  GitHubRepoSearchResult.swift
//  Vault
//
//  Created by Austin Vesich on 6/24/24.
//

struct GitHubRepoAPIResult: Codable {
    let name: String
    let htmlURLString: String
    let ownerUsername: String
    let ownerAvatarURLString: String
}

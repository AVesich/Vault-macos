//
//  GitHubPullRequestAPIResult.swift
//  Vault
//
//  Created by Austin Vesich on 7/19/24.
//

struct GitHubPullRequestAPIResult {
    let authorUsername: String?
    let authorAvatarURLString: String?
    let closed: Bool
    let merged: Bool
    let title: String
    let htmlURLString: String
    let baseRefName: String
    let headRefName: String
}

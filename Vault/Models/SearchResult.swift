//
//  SearchResponse.swift
//  Vault
//
//  Created by Austin Vesich on 5/21/24.
//

import Foundation
import SwiftUI

protocol SearchResult: Identifiable {
    associatedtype V: View
    associatedtype SearchContent
    
    var id: UUID { get }
    var content: SearchContent { get }
    var activityIcon: Image { get }
    var view: V { get }
    
    init (content: SearchContent)
}

struct TextResult: SearchResult {
    let id = UUID()
    let content: String
    let activityIcon = Image(systemName: "return")
    var view: some View {
        Text(content)
    }
}

struct HistoryResult: SearchResult {
    let id = UUID()
    let content: Search
    let activityIcon = Image(systemName: "return")
    var view: some View {
        TextResultView(result: self,
                       text: content.text)
    }
}

struct ModeResult: SearchResult {
    let id = UUID()
    let content: SearchMode
    let activityIcon = Image(systemName: "return")
    var view: some View {
        TextResultView(result: self,
                       text: content.name)
    }
}

struct FileResult: SearchResult {
    let id = UUID()
    let content: URL
    let activityIcon = Image(systemName: "arrow.up.right.square")
    var view: some View {
        FilePathResultView(filePath: content)
    }
}

struct ColorResult: SearchResult {
    let id = UUID()
    let content: [Color]
    let activityIcon = Image(systemName: "document.on.document.fill")
    var view: some View {
        ColorResultView(colors: content)
    }
}

struct FontResult: SearchResult {
    let id = UUID()
    let content: NSFont
    let activityIcon = Image(systemName: "document.on.document.fill")
    var view: some View {
        FontResultView(font: content)
    }
}

struct ImagesResult: SearchResult {
    let id = UUID()
    let content: [PhotoURLs]
    let activityIcon = Image(systemName: "app.fill")
    var view: some View {
        ImagesResultView(photoURLs: content)
    }
}

struct GitHubRepoResult: SearchResult {
    let id = UUID()
    let content: GitHubRepoAPIResult
    let activityIcon = Image(systemName: "link")
    var view: some View {
        GitHubRepoResultView(repoResult: content)
    }
}

struct GitHubUserResult: SearchResult {
    let id = UUID()
    let content: GitHubUserAPIResult
    let activityIcon = Image(systemName: "link")
    var view: some View {
        GitHubUserResultView(userResult: content)
    }
}

struct GitHubPullRequestResult: SearchResult {
    let id = UUID()
    let content: GitHubPullRequestAPIResult
    let activityIcon = Image(systemName: "link")
    var view: some View {
        GitHubPullRequestResultView(pullRequestResult: content)
    }
}

struct WebResult: SearchResult {
    let id = UUID()
    let content: String
    let activityIcon = Image(systemName: "link")
    var view: some View {
        WebResultView(urlString: content)
    }
}

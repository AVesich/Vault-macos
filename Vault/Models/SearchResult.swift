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
    var actionFunction: (() -> ())? { get }
    var view: V { get }
    
    init (content: SearchContent)
}

struct TextResult: SearchResult {
    let id = UUID()
    let content: String
    let activityIcon = Image(systemName: "return")
    var actionFunction: (() -> ())? = nil
    var view: some View {
        Text(content)
    }
    
    init(content: String) {
        self.content = content
    }
}

struct HistoryResult: SearchResult {
    let id = UUID()
    let content: Search
    let activityIcon = Image(systemName: "return")
    var actionFunction: (() -> ())? = nil
    var view: some View {
        TextResultView(result: self,
                       text: content.text)
    }
    
    init(content: Search) {
        self.content = content
    }
}

struct ModeResult: SearchResult {
    let id = UUID()
    let content: SearchMode
    let activityIcon = Image(systemName: "return")
    var actionFunction: (() -> ())? = nil
    var view: some View {
        TextResultView(result: self,
                       text: content.name)
    }
    
    init(content: SearchMode) {
        self.content = content
    }
}

struct FileResult: SearchResult {
    let id = UUID()
    let content: URL
    let activityIcon = Image(systemName: "arrow.up.right.square")
    var actionFunction: (() -> ())? { openInFinder }
    var view: some View {
        FilePathResultView(filePath: content)
    }
    
    private func openInFinder() {
        NSWorkspace.shared.activateFileViewerSelecting([content])
    }
}

struct ColorResult: SearchResult {
    let id = UUID()
    let content: [Color]
    let activityIcon = Image(systemName: "document.on.document.fill")
    var actionFunction: (() -> ())? = nil
    var view: some View {
        ColorResultView(colors: content)
    }
    
    init(content: [Color]) {
        self.content = content
    }
}

struct FontResult: SearchResult {
    let id = UUID()
    let content: NSFont
    let activityIcon = Image(systemName: "document.on.document.fill")
    var actionFunction: (() -> ())? { copyFontName }
    var view: some View {
        FontResultView(font: content)
    }
    
    private func copyFontName() {
        NSPasteboard.general.declareTypes([.string], owner: nil)
        NSPasteboard.general.setString(content.fontName, forType: .string)
    }
}

struct ImagesResult: SearchResult {
    let id = UUID()
    let content: [PhotoURLs]
    let activityIcon = Image(systemName: "app.fill")
    var actionFunction: (() -> ())? = nil
    var view: some View {
        ImagesResultView(photoURLs: content)
    }
    
    init(content: [PhotoURLs]) {
        self.content = content
    }
}

struct GitHubRepoResult: SearchResult {
    let id = UUID()
    let content: GitHubRepoAPIResult
    let activityIcon = Image(systemName: "link")
    var actionFunction: (() -> ())? { openRepoURL }
    var view: some View {
        GitHubRepoResultView(repoResult: content)
    }
    
    private func openRepoURL() {
        if let url = URL(string: content.htmlURLString) {
            NSWorkspace.shared.open(url)
        }
    }
}

struct GitHubUserResult: SearchResult {
    let id = UUID()
    let content: GitHubUserAPIResult
    let activityIcon = Image(systemName: "link")
    var actionFunction: (() -> ())? { openUserUrl }
    var view: some View {
        GitHubUserResultView(userResult: content)
    }
    
    private func openUserUrl() {
        if let url = URL(string: content.htmlURLString) {
            NSWorkspace.shared.open(url)
        }
    }
}

struct GitHubPullRequestResult: SearchResult {
    let id = UUID()
    let content: GitHubPullRequestAPIResult
    let activityIcon = Image(systemName: "link")
    var actionFunction: (() -> ())? { openPRUrl }
    var view: some View {
        GitHubPullRequestResultView(pullRequestResult: content)
    }
    
    private func openPRUrl() {
        if let url = URL(string: content.htmlURLString) {
            NSWorkspace.shared.open(url)
        }
    }
}

struct WebResult: SearchResult {
    let id = UUID()
    let content: String
    let activityIcon = Image(systemName: "link")
    var actionFunction: (() -> ())? { openURLInGoogle }
    var view: some View {
        WebResultView(urlString: content)
    }
    
    private func openURLInGoogle() {
        if let url = URL(string: content) {
            NSWorkspace.shared.open(url)
        }
    }
}

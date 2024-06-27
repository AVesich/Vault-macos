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
    var view: V { get }
}

struct TextResult: SearchResult {
    let id = UUID()
    let content: String
    var view: some View {
        Text(content)
    }
}

struct ModeResult: SearchResult {
    let id = UUID()
    let content: SearchModeType
    var view: some View {
        SearchModeResultView(searchMode: content)
    }
}

struct FileResult: SearchResult {
    let id = UUID()
    let content: URL
    var view: some View {
        FilePathResultView(filePath: content)
    }
}

struct ColorResult: SearchResult {
    let id = UUID()
    let content: [Color]
    var view: some View {
        ColorResultView(colors: content)
    }
}

struct FontResult: SearchResult {
    let id = UUID()
    let content: NSFont
    var view: some View {
        FontResultView(font: content)
    }
}

struct ImagesResult: SearchResult {
    let id = UUID()
    let content: [PhotoURLs]
    var view: some View {
        ImagesResultView(photoURLs: content)
    }
}

struct GitHubRepoResult: SearchResult {
    let id = UUID()
    let content: GitHubRepoSearchResult
    var view: some View {
        GitHubResultView(repoResult: content)
    }
}

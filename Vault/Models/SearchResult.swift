//
//  SearchResponse.swift
//  Vault
//
//  Created by Austin Vesich on 5/21/24.
//

import Foundation
import SwiftUI

enum SearchResultStyle {
    case text
    case searchMode
    case systemFile
    case colorGroup
    case font
    case images
    case gitHubRepo
}

protocol SearchResult: Identifiable {
    associatedtype SearchContent
    
    var id: UUID { get }
    var content: SearchContent { get }
    var view: any View { get }
}

struct TextResult: SearchResult {
    let id = UUID()
    let content: String
    var view: any View {
        Text(content)
    }
}

struct ModeResult: SearchResult {
    let id = UUID()
    let content: SearchMode
    var view: any View {
        SearchModeResultView(searchMode: content)
    }
}

struct FileResult: SearchResult {
    let id = UUID()
    let content: URL
    var view: any View {
        FilePathResultView(filePath: content)
    }
}

struct ColorResult: SearchResult {
    let id = UUID()
    let content: [Color]
    var view: any View {
        ColorResultView(colors: content)
    }
}

struct FontResult: SearchResult {
    let id = UUID()
    let content: NSFont
    var view: any View {
        FontResultView(font: content)
    }
}

struct ImagesResult: SearchResult {
    let id = UUID()
    let content: [PhotoURLs]
    var view: any View {
        ImagesResultView(photoURLs: content)
    }
}

struct GitHubRepoResult: SearchResult {
    let id = UUID()
    let content: GitHubRepoSearchResult
    var view: any View {
        GitHubResultView(repoResult: content)
    }
}


/*struct SearchResult: Identifiable, Equatable {
    let id = UUID()
    
    var resultStyle: SearchResultStyle
    var text: String?
    var searchMode: SearchMode?
    var filePath: URL?
    var colors: [Color]?
    var font: NSFont?
    var imageURLs: [PhotoURLs]?
    var gitHubRepoResult: GitHubRepoSearchResult?
    
    static func == (lhs: SearchResult, rhs: SearchResult) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Initializers
extension SearchResult {
    init(text: String) {
        self.resultStyle = .text
        self.text = text
    }
    
    init(filePath: URL) {
        self.resultStyle = .systemFile
        self.filePath = filePath
    }
    
    init(colors: [Color]) {
        self.resultStyle = .colorGroup
        self.colors = colors
    }

    init(font: NSFont) {
        self.resultStyle = .font
        self.font = font
    }
    
    init (imageURLs: [PhotoURLs]) {
        self.resultStyle = .images
        self.imageURLs = imageURLs
    }
    
    init (searchMode: SearchMode) {
        self.resultStyle = .searchMode
        self.searchMode = searchMode
    }
    
    init (gitHubRepoResult: GitHubRepoSearchResult) {
        self.resultStyle = .gitHubRepo
        self.gitHubRepoResult = gitHubRepoResult
    }
}
*/

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
}

struct SearchResult: Identifiable, Equatable {
    let id = UUID()
    
    var resultStyle: SearchResultStyle
    var text: String?
    var searchMode: SearchMode?
    var filePath: URL?
    var colors: [Color]?
    var font: NSFont?
    var imageURLs: [PhotoURLs]?
    
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
}

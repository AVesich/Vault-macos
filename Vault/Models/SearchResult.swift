//
//  SearchResponse.swift
//  Vault
//
//  Created by Austin Vesich on 5/21/24.
//

import Foundation

enum SearchResultStyle {
    case text
    case systemFile
}

struct SearchResult: Identifiable {
    let id = UUID()
    
    var resultStyle: SearchResultStyle
    var text: String?
    var filePath: URL?
}

// MARK: - Initializers
extension SearchResult {
    init(text: String, filePath: URL? = nil) {
        self.resultStyle = .text
        self.text = text
        self.filePath = filePath
    }
    
    init(text: String? = nil, filePath: URL) {
        self.resultStyle = .systemFile
        self.text = text
        self.filePath = filePath
    }
}

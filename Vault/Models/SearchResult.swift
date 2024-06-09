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
    case systemFile
    case colorGroup
}

struct SearchResult: Identifiable {
    let id = UUID()
    
    var resultStyle: SearchResultStyle
    var text: String?
    var filePath: URL?
    var colors: [Color]?
}

// MARK: - Initializers
extension SearchResult {
    init(text: String, filePath: URL? = nil, colors: [Color]? = nil) {
        self.resultStyle = .text
        self.text = text
        self.filePath = filePath
        self.colors = colors
    }
    
    init(text: String? = nil, filePath: URL, colors: [Color]? = nil) {
        self.resultStyle = .systemFile
        self.text = text
        self.filePath = filePath
        self.colors = colors
    }
    
    init(text: String? = nil, filePath: URL? = nil, colors: [Color]) {
        self.resultStyle = .colorGroup
        self.text = text
        self.filePath = filePath
        self.colors = colors
    }

}

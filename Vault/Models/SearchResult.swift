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
    case font
    case image
}

struct SearchResult: Identifiable {
    let id = UUID()
    
    var resultStyle: SearchResultStyle
    var text: String?
    var filePath: URL?
    var colors: [Color]?
    var font: Font?
    var image: Image?
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

    init(font: Font) {
        self.resultStyle = .font
        self.font = font
    }
    
    init (image: Image) {
        self.resultStyle = .image
        self.image = image
    }
}

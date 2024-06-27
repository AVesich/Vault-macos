//
//  ModeSearchEngine.swift
//  Vault
//
//  Created by Austin Vesich on 6/18/24.
//

import Foundation
import SwiftUI

enum SearchModeType: String {
    case codeSnippets = "Code Snippets"
    case colors = "Colors"
    case files = "Files"
    case fonts = "Fonts"
    case gitHub = "GitHub"
    case icons = "Icons"
    case images = "Images"
    case math = "Math"
    case modes = "Hidden to user"
    case stackOverflow = "Stack Overflow"
}

class ModeSearchEngine: Engine {
    
    // MARK: - Declaring properties
    public var delegate: EngineDelegate?
    internal var searchResults = [ModeResult]() {
        didSet {
            delegate?.engineDidFindResults(results: searchResults)
        }
    }
    public var searchMode: SearchMode {
        SearchMode(name: "",
                   systemIconName: "",
                   filters: searchFilters,
                   filterDefault: nil,
                   areFiltersExclusive: false)
    }
    internal var searchFilters = [SearchFilter]()
    private let modes: [String : SearchModeType] = [
        "Code Snippets": .codeSnippets,
        "Colors": .colors,
        "Files": .files,
        "Fonts": .fonts,
        "GitHub": .gitHub,
        "Icons": .icons,
        "Images": .images,
        "Math": .math,
        "Stack Overflow": .stackOverflow
    ]

    // Nothing crazy for the search algorithm here. Mode count should never end up exceeding 20-30, so there should be no performance issues doing a simple search
    public func search(withQuery query: String, inActiveDirectory activeDirectory: String) {
        guard !query.isEmpty else {
            return
        }
        var results = [ModeResult]()
        let pastSlashIndex = query.index(query.startIndex, offsetBy: 1)
        let queryWithoutSlash = query.lowercased()[pastSlashIndex...]
        
        for modeName in modes.keys {
            if modeName.lowercased().contains(queryWithoutSlash) {
                results.append(ModeResult(content: modes[modeName]!))
            }
        }
        
        // We just made the results with search modes and the result mode names MUST contain our query, so force unwrap everything here.
        results.sort {
            $0.content.rawValue.lowercased().range(of: queryWithoutSlash)!.lowerBound
            <
            $1.content.rawValue.lowercased().range(of: queryWithoutSlash)!.lowerBound
        }
        
        searchResults = results
    }
}

//
//  ModeSearchEngine.swift
//  Vault
//
//  Created by Austin Vesich on 6/18/24.
//

import Foundation

enum SearchMode: String {
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
    internal var searchResults = [SearchResult]()
    private let modes: [String : SearchMode] = [
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
    public func search(withQuery query: String, inActiveDirectory activeDirectory: String) async {
        var results = [SearchResult]()
        let pastSlashIndex = query.index(query.startIndex, offsetBy: 1)
        let queryWithoutSlash = query.lowercased()[pastSlashIndex...]
        
        for modeName in modes.keys {
            if modeName.lowercased().contains(queryWithoutSlash) {
                results.append(SearchResult(searchMode: modes[modeName]!))
            }
        }
        
        delegate?.engineDidFindResults(results: results)
    }
}

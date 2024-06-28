//
//  SearchModel.swift
//  Vault
//
//  Created by Austin Vesich on 5/18/24.
//

import SwiftUI

enum SearchModeEnum {
    static var files = SearchMode(name: "Files",
                                  systemIconName: "document.fill",
                                  engine: FileSystemSearchEngine())
    static var images = SearchMode(name: "Images",
                                   systemIconName: "photo.fill",
                                   engine: UnsplashSearchEngine())
    static var fonts = SearchMode(name: "Fonts",
                                  systemIconName: "textformat",
                                  engine: FontSearchEngine(),
                                  allowMultipleFilterSelections: true)
    static var github = SearchMode(name: "GitHub",
                                   systemIconName: "cat.fill",
                                   engine: GitHubSearchEngine())
}

@Observable
class Search {
    
    // MARK: - Search Modes
    public var activeMode: SearchMode? = nil {
        didSet {
            if activeMode != nil {
                queryString = ""
                results.removeAll()
            }
        }
    }
    private var modeList: [String : SearchMode] { // All modes instantiated below in an extension
        ["Files": SearchModeEnum.files,
         "Fonts": SearchModeEnum.fonts,
         "GitHub": SearchModeEnum.github,
         "Images": SearchModeEnum.images]
    }
    
    // MARK: - Query Properties
    private var queryString: String = "" {
        didSet {
            if let first = queryString.first,
               first == "/" {
                activeMode = nil
                searchModes() // No directory needed in mode search
            }
        }
    }
    public var queryBinding: Binding<String> {
        Binding {
            return self.queryString
        } set: { newQuery in
            self.queryString = newQuery
        }
    }
        
    // MARK: - Properties
    public var results = [any SearchResult]()

    init() {
        setupDelegates()
    }
    
    // MARK: - Methods
    private func setupDelegates() {
        SearchModeEnum.files.engine.delegate = self
        SearchModeEnum.images.engine.delegate = self
        SearchModeEnum.fonts.engine.delegate = self
        SearchModeEnum.github.engine.delegate = self
    }
    
    // Nothing crazy for the search algorithm here. Mode count should never end up exceeding 20-30, so there should be no performance issues doing a simple search
    public func searchModes() {
        guard !queryString.isEmpty else {
            return
        }
        var results = [ModeResult]()
        let lowerQuery = queryString.lowercased()
        let pastSlashIndex = lowerQuery.index(lowerQuery.startIndex, offsetBy: 1)
        let queryWithoutSlash = lowerQuery.lowercased()[pastSlashIndex...]
        
        for modeName in modeList.keys {
            if modeName.lowercased().contains(queryWithoutSlash) {
                results.append(ModeResult(content: modeList[modeName]!))
            }
        }
        
        // We just made the results with search modes and the result mode names MUST contain our query, so force unwrap everything here.
        results.sort {
            $0.content.name.lowercased().range(of: queryWithoutSlash)!.lowerBound
            <
            $1.content.name.lowercased().range(of: queryWithoutSlash)!.lowerBound
        }
        
        // Rare case this is called in a non-search method. DO NOT DO THIS ANYWHERE ELSE.
        // Calling convention for all other cases is to call this after running a private search method inside of the main public search method of an engine.
        engineDidFindResults(results: results)
    }
    
    public func enterPressedSearch(withActiveDirectory activeDirectory: String) {
        if let activeMode {
            search(withActiveDirectory: activeDirectory)
        } else {
            if let result = results.first as? ModeResult {
                activeMode = result.content
            }
        }
    }

    private func search(withActiveDirectory activeDirectory: String) {
        activeMode?.engine.search(withQuery: queryString, inActiveDirectory: activeDirectory)
    }
}

extension Search: EngineDelegate {
    func engineDidFindResults(results: [any SearchResult]) {
        self.results = results
    }
}

//
//  SearchModel.swift
//  Vault
//
//  Created by Austin Vesich on 5/18/24.
//

import SwiftUI
import SwiftData

enum SearchModeEnum {
    static var files = SearchMode(modeType: .file,
                                  systemIconName: "document.fill",
                                  engine: FileSystemSearchEngine())
    static var images = SearchMode(modeType: .images,
                                   systemIconName: "photo.fill",
                                   engine: UnsplashSearchEngine())
    static var fonts = SearchMode(modeType: .font,
                                  systemIconName: "textformat",
                                  engine: FontSearchEngine(),
                                  allowMultipleFilterSelections: true)
    static var github = SearchMode(modeType: .github,
                                   systemIconName: "cat.fill",
                                   engine: GitHubSearchEngine(),
                                   defaultFilterIndex: 0)
}

@Observable
class GlobalSearch {
    // MARK: - Search Modes
    public var activeMode: SearchMode? = nil {
        didSet {
            if activeMode != nil {
                queryString = ""
                foundResults.removeAll()
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
    
    // MARK: - Result Properties
    public var publishedResults: [any SearchResult] {
        if queryString.isEmpty || queryString=="/" {
            print(getHistory())
            return getHistory()
        }
        return foundResults
    }
    private var foundResults = [any SearchResult]()
        
    // MARK: - Dependencies
    public var modelContext: ModelContext!

    // MARK: - Initialization
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        setupDelegates()
    }
    
    // MARK: - Methods
    private func setupDelegates() {
        SearchModeEnum.files.engine.delegate = self
        SearchModeEnum.images.engine.delegate = self
        SearchModeEnum.fonts.engine.delegate = self
        SearchModeEnum.github.engine.delegate = self
    }
    
    private func getHistory() -> [HistoryResult] {
        let activeModeType: SearchModeType = (activeMode==nil) ? .mode : activeMode!.modeType
        
        let fetchDiscriptor = FetchDescriptor<Search>(
            predicate: #Predicate { $0.typeRawValue == activeModeType.rawValue },
            sortBy: [SortDescriptor(\.date)]
        )
        
        do {
            let searchHistory = try modelContext.fetch(fetchDiscriptor)
            return searchHistory.map { HistoryResult(content: $0) }
        } catch {
            print(error)
        }
        return [HistoryResult]()
    }
    
    // Nothing crazy for the search algorithm here. Mode count should never end up exceeding 20-30, so there should be no performance issues doing a simple search
    public func searchModes() {
        guard !queryString.isEmpty else {
            return
        }
        var foundResults = [ModeResult]()
        let lowerQuery = queryString.lowercased()
        let pastSlashIndex = lowerQuery.index(lowerQuery.startIndex, offsetBy: 1)
        let queryWithoutSlash = lowerQuery.lowercased()[pastSlashIndex...]
        
        for modeName in modeList.keys {
            if modeName.lowercased().contains(queryWithoutSlash) {
                foundResults.append(ModeResult(content: modeList[modeName]!))
            }
        }
        
        // We just made the foundResults with search modes and the result mode names MUST contain our query, so force unwrap everything here.
        foundResults.sort {
            $0.content.name.lowercased().range(of: queryWithoutSlash)!.lowerBound
            <
            $1.content.name.lowercased().range(of: queryWithoutSlash)!.lowerBound
        }
        
        // Rare case this is called in a non-search method. DO NOT DO THIS ANYWHERE ELSE.
        // Calling convention for all other cases is to call this after running a private search method inside of the main public search method of an engine.
        engineDidFindResults(results: foundResults)
    }
    
    public func enterPressedSearch(withActiveDirectory activeDirectory: String) {
        guard !queryString.isEmpty else {
            return
        }
        
        if let activeMode {
            modelContext.insert(Search(text: queryString,
                                       date: .now,
                                       typeValue: activeMode.modeType.rawValue))
            try? modelContext.save()
            search(withActiveDirectory: activeDirectory)
        } else {
            if let result = foundResults.first as? ModeResult {
                modelContext.insert(Search(text: result.content.name,
                                           date: .now,
                                           typeValue: SearchModeType.mode.rawValue))
                try? modelContext.save()
                activeMode = result.content
            }
        }
    }

    private func search(withActiveDirectory activeDirectory: String) {
        activeMode?.engine.search(withQuery: queryString, inActiveDirectory: activeDirectory)
    }
}

extension GlobalSearch: EngineDelegate {
    func engineDidFindResults(results: [any SearchResult]) {
        self.foundResults = results
    }
}

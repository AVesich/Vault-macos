//
//  SearchModel.swift
//  Vault
//
//  Created by Austin Vesich on 5/18/24.
//

import SwiftUI
import SwiftData

extension SearchModeEnum {
    static func modeForTypeID(_ typeID: Int) -> SearchMode {
        switch typeID {
        // 0 is Mode, but we never need to set that mode manually
        case 1:
            return files
        case 2:
            return images
        case 3:
            return fonts
        case 4:
            return github
        case 5:
            return web
        default:
            return files
        }
    }
}

@Observable
class GlobalSearch {
    // MARK: - Search Modes
    public var activeMode: SearchMode? = nil {
        willSet {
            activeModeWillChange()
        }
        didSet {
            activeModeChanged()
        }
    }
    
    // MARK: - Query Properties
    private var queryString: String = "" {
        didSet {
            queryStringChanged()
        }
    }
    public var queryBinding: Binding<String> {
        Binding {
            return self.queryString
        } set: { newQuery in
            self.queryString = newQuery
        }
    }
    private var selectedFilterIndices: Set<Int> = Set<Int>() {
        didSet {
            filterIndicesChanged()
        }
    }
    public var filterBinding: Binding<Set<Int>> {
        Binding {
            return self.selectedFilterIndices
        } set: { newIndices in
            self.selectedFilterIndices = newIndices
        }
    }
    
    // MARK: - Result Properties
    public var publishedResults: [any SearchResult] {
        if foundResults.isEmpty && (queryString.isEmpty || queryString=="/") {
            return getHistory()
        }
        return foundResults
    }
    private var foundResults = [any SearchResult]()
    public var canAutocomplete: Bool {
        return (queryString.isEmpty && foundResults.isEmpty) || (queryString.first == "/") // We are only showing history or mode results
    }
        
    // MARK: - Dependencies
    public var modelContext: ModelContext!

    // MARK: - Initialization
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        setupDelegates()
    }
    
    // MARK: - Methods
    private func setupDelegates() {
        SearchModeEnum.modes.engine.delegate = self
        SearchModeEnum.files.engine.delegate = self
        SearchModeEnum.images.engine.delegate = self
        SearchModeEnum.fonts.engine.delegate = self
        SearchModeEnum.github.engine.delegate = self
    }
        
    public func enterPressedSearch(withActiveDirectory activeDirectory: String) {
        if queryString.isEmpty || queryString=="/" { // Autocomplete
            autocompleteSearch(fromIndex: 0)
        } else {
            makeSearchWithHistory()
        }
    }
    
    public func autocompleteSearch(fromIndex index: Int) {
        guard index < publishedResults.count,
              let historyElement = publishedResults[index].content as? Search else {
            return
        }
        
        if let modeID = historyElement.selectingModeID {
            activeMode = SearchModeEnum.modeForTypeID(modeID)
        } else {
            queryString = historyElement.text
            search(withActiveDirectory: "")
        }
    }
        
    private func makeSearchWithHistory() {
        if let result = foundResults.first as? ModeResult {
            print(result.content.modeFilterType.id)
            modelContext.insert(Search(text: "/"+result.content.name,
                                       selectingModeID: result.content.modeFilterType.id,
                                       filterModeID: SearchModeType.mode.id))
            activeMode = result.content
        } else if let activeMode {
            modelContext.insert(Search(text: queryString,
                                       filterModeID: activeMode.modeFilterType.id))
            search(withActiveDirectory: "")
        }
        try? modelContext.save()
    }

    private func search(withActiveDirectory activeDirectory: String) {
        let activeMode = activeMode ?? SearchModeEnum.modes
        activeMode.engine.search(withQuery: queryString, inActiveDirectory: activeDirectory)
    }
        
    public func refreshResults() {
        search(withActiveDirectory: "")
    }
    
    // MARK: - Attribute helpers
    private func getHistory() -> [HistoryResult] {
        let activeModeType: SearchModeType = (activeMode==nil) ? .mode : activeMode!.modeFilterType
        
        let fetchDiscriptor = FetchDescriptor<Search>(
            predicate: #Predicate { $0.filterModeID == activeModeType.id },
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        
        do {
            let searchHistory = try modelContext.fetch(fetchDiscriptor)
            return searchHistory.map { HistoryResult(content: $0) }
        } catch {
            print(error)
        }
        return [HistoryResult]()
    }

    private func queryStringChanged() {
        let activeMode = activeMode ?? SearchModeEnum.modes

        if queryString.isEmpty && selectedFilterIndices.isEmpty { // Clear results after deleting the current query, just feels good as feedback
            clearResults()
        } else if queryString.isEmpty && activeMode.resultUpdateStyle == .onQueryOrFilter { //
            if !selectedFilterIndices.isEmpty {
                search(withActiveDirectory: "")
            }
        } else { // Default to mode search & search if mode supports active results
            if let first = queryString.first,
               first == "/" {
                self.activeMode = nil
            }
            if activeMode.resultUpdateStyle == .active { // Actively search & update results if the engine wants active results
                search(withActiveDirectory: "")
            }
        }
    }
    
    private func activeModeWillChange() {
        activeMode?.engine.clearResults()
    }
    
    private func activeModeChanged() {
        if activeMode != nil {
            queryString = ""
            selectedFilterIndices.removeAll()
            if let defaultFilterIndex = activeMode?.defaultFilterIndex {
                selectedFilterIndices.insert(defaultFilterIndex)
            }
        }
    }
    
    private func filterIndicesChanged() {
        if selectedFilterIndices.isEmpty && queryString.isEmpty {
            clearResults()
        } else {
            refreshResults()
        }
    }
    
    private func clearResults() {
        foundResults.removeAll()
    }
}

extension GlobalSearch: EngineDelegate {
    func engineDidFindResults(results: [any SearchResult]) {
        self.foundResults = results
    }
}

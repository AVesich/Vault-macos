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
    public var activeMode: SearchMode = SearchModeEnum.modes {
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
    
    // MARK: - Filter properties
    private var filtersNeedReset: Bool = false // This is set to true when the mode changes & prevents refresh due to the initial filter reset
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
        let activeMode = activeMode
        return (queryString.isEmpty && foundResults.isEmpty) || activeMode.canAutocomplete // We are only showing history or complete-able results
    }
    private let MAX_HISTORY_SIZE = 5
    
    // MARK: - Fields
    private var isSearching = false
        
    // MARK: - Dependencies
    public var modelContext: ModelContext!

    // MARK: - Initialization
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        setupDelegates()
    }
    
    // MARK: - Methods
    private func setupDelegates() {
        SearchModeEnum.modes.engine.delegate = self // Not searchable, so it's excluded from the dict iterated below
        for mode in SearchModeEnum.searchModes.values {
            mode.engine.delegate = self
        }
    }
        
    public func enterPressedSearch(withActiveDirectory activeDirectory: String) {
        if canAutocomplete { // Autocomplete
            let activeMode = activeMode ?? SearchModeEnum.modes
            if let autocompleteBehavior = activeMode.engine.autocompleteMethod,
               !foundResults.isEmpty {
                autocompleteBehavior()
            } else {
                autocompleteSearch(fromIndex: 0)
            }
        } else {
            makeSearchWithHistory()
        }
    }
    
    public func autocompleteSearch(fromIndex index: Int) { // Autocomplete a history result or a mode search, make this more general if needed later
        guard index < publishedResults.count else {
            return
        }
        
        if let historyElement = publishedResults[index].content as? Search {
            if let modeID = historyElement.selectingModeID {
                activeMode = SearchModeEnum.modeForTypeID(modeID)
            } else {
                queryString = historyElement.text
                search(withActiveDirectory: "")
            }
        } else if let resultMode = publishedResults[index].content as? SearchMode {
            makeSearchWithHistory() // Adds history & updates mode
        }
    }
        
    private func makeSearchWithHistory() {
        if let result = foundResults.first as? ModeResult {
            modelContext.insert(Search(text: "/"+result.content.name,
                                       selectingModeID: result.content.modeFilterType.id,
                                       filterModeID: SearchModeType.mode.id))
            activeMode = result.content
        } else {
            modelContext.insert(Search(text: queryString,
                                       filterModeID: activeMode.modeFilterType.id))
            search(withActiveDirectory: "")
        }
        try? modelContext.save()
    }

    private func search(withActiveDirectory activeDirectory: String) {
        if isSearching {
            return
        }
        isSearching = true
        Task {
            await activeMode.engine.search(withQuery: queryString, inActiveDirectory: activeDirectory)
            isSearching = false
        }
    }
        
    public func refreshResults() {
        search(withActiveDirectory: "")
    }
    
    // MARK: - Attribute helpers
    private func getHistory() -> [HistoryResult] {
        let activeFilterID = activeMode.modeFilterType.id
        let fetchDiscriptor = FetchDescriptor<Search>(
            predicate: #Predicate { $0.filterModeID == activeFilterID },
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        
        do {
            var searchHistory = try modelContext.fetch(fetchDiscriptor)
            pruneHistoryToMaxSize(&searchHistory)
            return searchHistory.map { HistoryResult(content: $0) }
        } catch {
            print(error)
        }
        
        return [HistoryResult]()
    }
    
    private func pruneHistoryToMaxSize(_ history: inout [Search]) {
        while history.count > MAX_HISTORY_SIZE {
            let lastHistory = history.removeLast()
            modelContext.delete(lastHistory)
        }
    }

    private func queryStringChanged() {
        if queryString.isEmpty && selectedFilterIndices.isEmpty { // Clear results after deleting the current query, just feels good as feedback
            clearResults()
        } else if queryString.isEmpty && activeMode.resultUpdateStyle == .onQueryOrFilter {
            if !selectedFilterIndices.isEmpty {
                search(withActiveDirectory: "")
            }
        } else { // Default to mode search & search if mode supports active results
            if let first = queryString.first,
               first == "/" {
                self.activeMode = SearchModeEnum.modes
            }
            if activeMode.resultUpdateStyle == .active { // Actively search & update results if the engine wants active results
                search(withActiveDirectory: "")
            }
        }
    }
    
    private func activeModeWillChange() {
        clearResults()
    }
    
    private func activeModeChanged() {
        filtersNeedReset = true
        resetFilters()
        if activeMode.modeFilterType != .mode { // Don't want to clear the '/'
            queryString = ""
        }
    }
    
    private func resetFilters() {
        selectedFilterIndices.removeAll()
        if let defaultIndex = activeMode.defaultFilterIndex {
            selectedFilterIndices.insert(defaultIndex)
        }
        filtersNeedReset = false
    }
    
    private func filterIndicesChanged() {
        if filtersNeedReset {
            return
        }
        
        if selectedFilterIndices.isEmpty && queryString.isEmpty {
            clearResults()
        } else {
            refreshResults()
        }
    }
    
    private func clearResults() {
        activeMode.engine.clearResults()
    }
}

extension GlobalSearch: EngineDelegate {
    func engineGotResults(results: [any SearchResult]) {
        DispatchQueue.main.sync { // TODO: - Find workaround to this problem - foundResults being updated by a non-main thread due to the delegate being called from a Task causes the app to crash
            self.foundResults = results
        }
    }
}

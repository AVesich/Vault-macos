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
    internal var foundResults = [any SearchResult]()
    public var canAutocomplete: Bool {
        return foundResults.isEmpty
    }
    private let MAX_HISTORY_SIZE = 5
    
    // MARK: - Fields
    private var isSearching = false
    public var selectedIndex: Int = 0
        
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
        
    public func specialAction(withIndex index: Int = -1) {
        let usedIndex = (index <= -1) ? selectedIndex : index
        
        if canAutocomplete { // Autocomplete
            searchWithResult(fromIndex: usedIndex)
        } else {
            if let modeAction = activeMode.engine.specialAction {
                modeAction(usedIndex)
            }
        }
    }
    
    public func searchWithResult(fromIndex resultIndex: Int) {
        if let historyElement = publishedResults[resultIndex].content as? Search {
            if historyElement.selectingModeID == nil {
                
            }
        }
        makeSearchWithHistory(andResultIndex: resultIndex)
    }
        
    private func makeSearchWithHistory(andResultIndex resultIndex: Int = 0) {
        defer {
            try? modelContext.save()
        }
        
        // Switch modes if necessary
        if let result = publishedResults[resultIndex] as? ModeResult { // Switch mode from mode result
            modelContext.insert(Search(text: "/"+result.content.name,
                                       selectingModeID: result.content.modeFilterType.id,
                                       filterModeID: SearchModeType.mode.id))
            activeMode = result.content
            return
        } else if let result = publishedResults[resultIndex] as? HistoryResult,
                  let modeID = result.content.selectingModeID { // Switch mode from history mode result
            let newMode = SearchModeEnum.modeForTypeID(modeID)
            modelContext.insert(Search(text: "/"+newMode.name,
                                       selectingModeID: modeID,
                                       filterModeID: SearchModeType.mode.id))
            activeMode = newMode
            return
        }
        
        if let result = publishedResults[resultIndex] as? HistoryResult { // Search from history
            queryString = result.content.text
        }
        modelContext.insert(Search(text: queryString,
                                   filterModeID: activeMode.modeFilterType.id))
        search(withActiveDirectory: "")
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
        foundResults.removeAll()
        activeMode.engine.clearResults()
    }
    
    public func moveSelectionUp() {
        if selectedIndex > 0 {
            selectedIndex -= 1
        }
    }
    
    public func moveSelectionDown() {
        if selectedIndex < (publishedResults.count-1) {
            selectedIndex += 1
        }
    }
}

extension GlobalSearch: EngineDelegate {
    func engineRetrievedResults(newResults: [any SearchResult]) {
        DispatchQueue.main.sync { // TODO: - Find workaround to this problem - foundResults being updated by a non-main thread due to the delegate being called from a Task causes the app to crash
            if activeMode.resultUpdateStyle == .active {
                foundResults.removeAll()
            }
            if activeMode.engine is UnsplashSearchEngine {
                var existingURLs = [PhotoURLs]()
                var newURLs = [PhotoURLs]()
                
                if let first = foundResults.first,
                   let urls = first.content as? [PhotoURLs] {
                    existingURLs = urls
                }
                if let first = newResults.first,
                   let urls = first.content as? [PhotoURLs] {
                    newURLs = urls
                }
                
                foundResults.removeAll()
                foundResults.append(ImagesResult(content: existingURLs + newURLs))
            } else {
                foundResults.append(contentsOf: newResults)
            }
        }
    }
    
    func engineRequestedResultsReset() {
        foundResults.removeAll()
    }
}

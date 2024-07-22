//
//  ModeAPI.swift
//  Vault
//
//  Created by Austin Vesich on 7/20/24.
//

enum SearchModeEnum {
    static let modes = SearchMode(modeType: .mode,
                                  resultUpdateStyle: .active,
                                  canAutocomplete: true,
                                  systemIconName: "",
                                  engine: ModeSearchEngine())
    static let files = SearchMode(modeType: .file,
                                  systemIconName: "document.fill",
                                  engine: FileSystemSearchEngine())
    static let images = SearchMode(modeType: .images,
                                   systemIconName: "photo.fill",
                                   engine: UnsplashSearchEngine())
    static let fonts = SearchMode(modeType: .font,
                                  resultUpdateStyle: .onQueryOrFilter,
                                  systemIconName: "textformat",
                                  engine: FontSearchEngine(),
                                  allowMultipleFilterSelections: true)
    static let github = SearchMode(modeType: .github,
                                   systemIconName: "cat.fill",
                                   engine: GitHubSearchEngine(),
                                   defaultFilterIndex: 0)
    static let web = SearchMode(modeType: .web,
                                resultUpdateStyle: .active,
                                canAutocomplete: true,
                                systemIconName: "globe",
                                engine: WebEngine())
    
    static var searchModes: [String: SearchMode] {
        return [
            "Files": files,
            "Fonts": fonts,
            "GitHub": github,
            "Images": images,
            "Web": web
        ]
    }
}

final class ModeAPI: API {
    
    // MARK: - Properties
    internal var apiConfig: APIConfig!
    internal var results = [any SearchResult]()
    internal var prevQuery: String? = nil
    internal var nextPageInfo: NextPageInfo<Int> = NextPageInfo<Int>(nextPageCursor: nil, hasNextPage: true)
    internal var isLoadingNewPage: Bool = false

    // MARK: - Methods
    internal func postInitSetup() { }

    internal func getResultData(for query: String) async -> APIResponse<PageCursorType> {
        guard !query.isEmpty && query.first == "/" else {
            return APIResponse(results: [ModeResult](), nextPageInfo: nextPageInfo) // Don't set new values, keep what we have & reject the result
        }
        var foundResults = [ModeResult]()
        let lowerQuery = query.lowercased()
        let pastSlashIndex = lowerQuery.index(lowerQuery.startIndex, offsetBy: 1)
        let queryWithoutSlash = lowerQuery.lowercased()[pastSlashIndex...]
                
        for modeName in SearchModeEnum.searchModes.keys {
            if modeName.lowercased().contains(queryWithoutSlash) {
                foundResults.append(ModeResult(content: SearchModeEnum.searchModes[modeName]!))
            }
        }
        
        // We just made the foundResults with search modes and the result mode names MUST contain our query, so force unwrap everything here.
        foundResults.sort {
            $0.content.name.lowercased().range(of: queryWithoutSlash)!.lowerBound
            <
            $1.content.name.lowercased().range(of: queryWithoutSlash)!.lowerBound
        }
        
        let startingIndexInt = nextPageInfo.nextPageCursor ?? 0 // Cursor isn't updated yet, so next cursor is start
        let endIndexInt = startingIndexInt+apiConfig.RESULTS_PER_PAGE
        let startingIndex = results.index(results.startIndex, offsetBy: startingIndexInt)
        let endingIndex = results.index(results.startIndex, offsetBy: endIndexInt)
        foundResults = Array(foundResults[startingIndex..<endingIndex])
        
        let hasResultsAvailable = endIndexInt < apiConfig.MAX_RESULTS
        let nextPageInfo = NextPageInfo(nextPageCursor: endIndexInt, hasNextPage: hasResultsAvailable)
        
        return APIResponse(results: foundResults, nextPageInfo: nextPageInfo)
    }
}

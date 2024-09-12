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
                                  engine: ModeSearchEngine())
    static let files = SearchMode(modeType: .file,
                                  engine: FileSystemSearchEngine())
    static let images = SearchMode(modeType: .images,
                                   engine: UnsplashSearchEngine())
    static let fonts = SearchMode(modeType: .font,
                                  resultUpdateStyle: .onQueryOrFilter,
                                  engine: FontSearchEngine(),
                                  allowMultipleFilterSelections: true)
    static let github = SearchMode(modeType: .github,
                                   engine: GitHubSearchEngine(),
                                   defaultFilterIndex: 0)
    static let web = SearchMode(modeType: .web,
                                resultUpdateStyle: .active,
                                canAutocomplete: true,
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

final class ModeAPI: LocalAPI {
    
    // MARK: - Properties
    internal var isReset: Bool = false
    internal var apiConfig: APIConfig!
    internal var prevQuery: String? = nil
    internal var nextPageInfo: NextPageInfo<Int> = NextPageInfo<Int>(nextPageCursor: nil, hasNextPage: true)
    internal var isLoadingNewPage: Bool = false
    internal var loadedPageCount: Int = 0

    // MARK: - Methods
    internal func postInitSetup() { }

    internal func getResultData(forQuery query: String) async -> APIResponse<Int> {
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
        
        let nextPageInfo = concatResultsAndGetPageInfo(foundResults: &foundResults)
        
        return APIResponse(results: foundResults, nextPageInfo: nextPageInfo)
    }
}

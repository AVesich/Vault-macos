//
//  ModeSearchEngine.swift
//  Vault
//
//  Created by Austin Vesich on 7/3/24.
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

class ModeSearchEngine: Engine {
    
    public var delegate: EngineDelegate?
    internal var searchResults = [ModeResult]() {
        didSet {
            delegate?.engineDidFindResults(results: searchResults)
        }
    }
    public let searchFilters = [SearchFilter]()
    public var autocomplete: (() -> ())? = nil
    
    func search(withQuery query: String, inActiveDirectory activeDirectory: String) {
        guard !query.isEmpty && query.first == "/" else {
            return
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
        
        searchResults = foundResults
    }
}

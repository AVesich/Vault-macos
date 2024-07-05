//
//  SearchMode.swift
//  Vault
//
//  Created by Austin Vesich on 6/26/24.
//

enum SearchModeType: Int, Codable, Identifiable {
    case mode
    case file
    case images
    case font
    case github
    case web
    
    var id: Int {
        return rawValue
    }
    
    var name: String {
        switch self {
        case .mode:
            return "Modes"
        case .file:
            return "Files"
        case .images:
            return "Images"
        case .font:
            return "Fonts"
        case .github:
            return "GitHub"
        case .web:
            return "Web"
        }
    }
}

enum SearchModeResultUpdateStyle {
    case active
    case onQuery
    case onQueryOrFilter
}

class SearchMode {
    public let modeFilterType: SearchModeType!
    public let resultUpdateStyle: SearchModeResultUpdateStyle!
    public var name: String {
        return modeFilterType.name
    }
    public let systemIconName: String!
    public var engine: (any Engine)!
    public var filters: [SearchFilter] {
        return engine.searchFilters
    }
    public let defaultFilterIndex: Int?
    public let allowMultipleFilterSelections: Bool!
    
    init (modeType: SearchModeType,
          resultUpdateStyle: SearchModeResultUpdateStyle = .onQuery,
          systemIconName: String,
          engine: any Engine,
          defaultFilterIndex: Int? = nil,
          allowMultipleFilterSelections: Bool = false) {
        self.modeFilterType = modeType
        self.resultUpdateStyle = resultUpdateStyle
        self.systemIconName = systemIconName
        self.engine = engine
        self.defaultFilterIndex = defaultFilterIndex
        self.allowMultipleFilterSelections = allowMultipleFilterSelections
    }
}

extension SearchMode: Equatable {
    static func == (_ lhs: SearchMode, _ rhs: SearchMode) -> Bool {
        return lhs.name == rhs.name
    }
}

//
//  SearchMode.swift
//  Vault
//
//  Created by Austin Vesich on 6/26/24.
//

enum SearchModeType {
    case mode
    case file
    case images
    case font
    case github
    
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
        }
    }
}

class SearchMode {
    public let modeType: SearchModeType!
    public var name: String {
        return modeType.name
    }
    public let systemIconName: String!
    public var engine: (any Engine)!
    public var filters: [SearchFilter] {
        return engine.searchFilters
    }
    public let defaultFilterIndex: Int?
    public let allowMultipleFilterSelections: Bool!
    
    init (modeType: SearchModeType,
          systemIconName: String,
          engine: any Engine,
          defaultFilterIndex: Int? = nil,
          allowMultipleFilterSelections: Bool = false) {
        self.modeType = modeType
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

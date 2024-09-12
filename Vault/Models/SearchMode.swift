//
//  SearchMode.swift
//  Vault
//
//  Created by Austin Vesich on 6/26/24.
//

// Stores attributes relating to a search mode that don't pretain to behavior of the mode itself
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
    
    var iconName: String {
        return PlistHelper.get(value: "ICON_NAME", from: name+"Config")
    }
}

// How often a mode should update it's results
enum SearchModeResultUpdateStyle {
    case active
    case onQuery
    case onQueryOrFilter
}

// Core attributes of a mode that describe how it should behave
class SearchMode {
    public let modeFilterType: SearchModeType
    public let resultUpdateStyle: SearchModeResultUpdateStyle
    private let canAutocomplete: Bool
    public var engine: (any Engine)
    public let defaultFilterIndex: Int?
    public let allowMultipleFilterSelections: Bool
    
    // MARK: - Computed Properties
    public var iconName: String{
        return modeFilterType.iconName
    }
    public var name: String {
        return modeFilterType.name
    }
    public var id: Int {
        return modeFilterType.id
    }
    public var filters: [SearchFilter] {
        return engine.searchFilters
    }
    
    // MARK: - Initialization
    init (modeType: SearchModeType,
          resultUpdateStyle: SearchModeResultUpdateStyle = .onQuery,
          canAutocomplete: Bool = false,
          engine: any Engine,
          defaultFilterIndex: Int? = nil,
          allowMultipleFilterSelections: Bool = false) {
        self.modeFilterType = modeType
        self.resultUpdateStyle = resultUpdateStyle
        self.canAutocomplete = canAutocomplete
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

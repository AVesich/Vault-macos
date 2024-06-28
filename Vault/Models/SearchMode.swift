//
//  SearchMode.swift
//  Vault
//
//  Created by Austin Vesich on 6/26/24.
//

class SearchMode {
    let name: String!
    let systemIconName: String!
    var engine: (any Engine)!
    var filters: [SearchFilter] {
        return engine.searchFilters
    }
    let defaultFilterIndex: Int?
    let allowMultipleFilterSelections: Bool!
    
    init (name: String,
          systemIconName: String,
          engine: any Engine,
          defaultFilterIndex: Int? = nil,
          allowMultipleFilterSelections: Bool = false) {
        self.name = name
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

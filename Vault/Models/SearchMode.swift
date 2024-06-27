//
//  SearchMode.swift
//  Vault
//
//  Created by Austin Vesich on 6/26/24.
//

struct SearchMode {
    let name: String
    let systemIconName: String
    let filters: [SearchFilter]
    let filterDefault: Int?
    let areFiltersExclusive: Bool
}

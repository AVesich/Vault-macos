//
//  Search.swift
//  Vault
//
//  Created by Austin Vesich on 6/28/24.
//

import SwiftData
import Foundation

@Model
final class Search {
    @Attribute(.unique) let text: String
    let selectingModeID: Int?
    let date: Date
    let filterModeID: Int
    
    init(text: String, selectingModeID: Int? = nil, date: Date = .now, filterModeID: Int) {
        self.text = text
        self.selectingModeID = selectingModeID
        self.date = date
        self.filterModeID = filterModeID
    }
}

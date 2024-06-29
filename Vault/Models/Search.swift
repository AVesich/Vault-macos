//
//  Search.swift
//  Vault
//
//  Created by Austin Vesich on 6/28/24.
//

import SwiftData
import Foundation

@Model
struct Search {
    let text: String
    let date: Date
    let type: SearchModeType
    
    init(text: String, date: Date, type: SearchModeType) {
        self.text = text
        self.date = date
        self.type = type
    }
}

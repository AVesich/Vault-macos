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
    let text: String
    let date: Date
    let typeRawValue: Int
    
    init(text: String, date: Date, typeValue: Int) {
        self.text = text
        self.date = date
        self.typeRawValue = typeValue
    }
}

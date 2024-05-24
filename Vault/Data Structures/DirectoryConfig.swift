//
//  DirectoryConfig.swift
//  Vault
//
//  Created by Austin Vesich on 5/23/24.
//

import SwiftData

@Model
final class DirectoryConfig {
    var directoryPath: String
    var directoryEmoji: String
    var isFavorited: Bool
    
    init(directoryPath: String, directoryEmoji: String, isFavorited: Bool) {
        self.directoryPath = directoryPath
        self.directoryEmoji = directoryEmoji
        self.isFavorited = isFavorited
    }
}

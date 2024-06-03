//
//  DirectoryConfig.swift
//  Vault
//
//  Created by Austin Vesich on 5/23/24.
//

import SwiftData
import Foundation

@Model
final class DirectoryProfile {
    var directoryPath: String
    var directoryEmoji: String
    var isFavorited: Bool
    
    init(directoryPath: String, directoryEmoji: String, isFavorited: Bool) {
        self.directoryPath = directoryPath
        self.directoryEmoji = directoryEmoji
        self.isFavorited = isFavorited
    }
    
    static var temporaryProfile = DirectoryProfile(directoryPath: FileManager.default.homeDirectoryForCurrentUser.relativePath,
                                                   directoryEmoji: "🚀",
                                                   isFavorited: false)
}

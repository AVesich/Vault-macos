//
//  StringExtension.swift
//  Vault
//
//  Created by Austin Vesich on 5/19/24.
//

import Foundation

extension String {
    func largestCompleteFilePath() -> String {
        let lastSlashIndex = self.lastIndex(of: "/") ?? self.startIndex
        return String(self[...lastSlashIndex])
    }
    
    func lastFilePathComponent() -> String {
        let lastSlashIndex = self.lastIndex(of: "/") ?? self.startIndex
        return String(self[lastSlashIndex...])
    }
}

//
//  StringExtension.swift
//  Vault
//
//  Created by Austin Vesich on 5/19/24.
//

import Foundation

extension String {
    func similarity(to goalString: String) -> Int {
        var score = 0
        var numCorrect = 0
        
        for (i, goalLetter) in goalString.enumerated() {
            if i < self.count {
                let stringIndex = self.index(self.startIndex, offsetBy: i)
                numCorrect += 1
                score += (String(goalLetter) == String(self[stringIndex])) ? 0 : numCorrect
            }
        }
        return score
    }
    
    func largestCompleteFilePath() -> String {
        let lastSlashIndex = self.lastIndex(of: "/") ?? self.startIndex
        return String(self[...lastSlashIndex])
    }
    
    func lastFilePathComponent() -> String {
        let lastSlashIndex = self.lastIndex(of: "/") ?? self.startIndex
        return String(self[lastSlashIndex...])
    }
    
    func substring(_ startIndex: Int, _ endIndex: Int) -> String {
        let start = self.index(self.startIndex, offsetBy: startIndex)
        let end = self.index(self.startIndex, offsetBy: endIndex)
        return String(self[start..<end])
    }
    
    func substring(_ startIndex: Int) -> String {
        print (startIndex)
        print(self.count)
        let start = self.index(self.startIndex, offsetBy: startIndex)
        return String(self[start..<self.endIndex])
    }
}

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
}

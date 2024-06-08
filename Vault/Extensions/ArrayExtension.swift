//
//  ArrayExtension.swift
//  Vault
//
//  Created by Austin Vesich on 6/8/24.
//

import Foundation

extension Array {
    func trimmed(toLength length: Int) -> Array {
        let lastIndexNumber = Swift.min(length, self.count)-1
        let lastIndex = self.index(self.startIndex, offsetBy: lastIndexNumber)
        if lastIndex < 0 {
            return []
        }
        return Array(self[...lastIndex])
    }
}

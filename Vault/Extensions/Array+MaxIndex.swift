//
//  Array+MaxIndex.swift
//  Vault
//
//  Created by Austin Vesich on 7/27/24.
//

extension Array {
    func getMaxIndex(desiredIndexInt: Int) -> Int {
        if self.isEmpty {
            return self.endIndex
        }
        var max = desiredIndexInt
        if desiredIndexInt > self.count {
            max = self.count
        }
        return max
    }
}

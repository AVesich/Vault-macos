//
//  StringExtension.swift
//  Vault
//
//  Created by Austin Vesich on 5/19/24.
//

import Foundation

extension String {
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

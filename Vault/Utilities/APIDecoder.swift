//
//  APIDecoder.swift
//  Vault
//
//  Created by Austin Vesich on 6/9/24.
//

import Foundation

struct APIDecoder<T: Codable> {
    func decodeValueFromData(_ data: Data) -> T? {
        let decoder = JSONDecoder()
        let result = try? decoder.decode(T.self, from: data)
        return result
    }
}

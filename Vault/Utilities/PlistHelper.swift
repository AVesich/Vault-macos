//
//  PlistHelper.swift
//  Vault
//
//  Created by Austin Vesich on 6/9/24.
//

import Foundation

struct PlistHelper {
    public static func getAPIPlistValue(forKey key: String) -> String {
        guard let filePath = Bundle.main.path(forResource: "APIKeys", ofType: "plist") else {
            fatalError("Failed to find APIKeys.plist")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: key) as? String else {
            fatalError("Couldn't find key '\(key)' in 'APIKeys.plist'.")
        }
        
        return value
    }
}

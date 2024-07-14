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
    
    public static func get<T>(value: String, from plistName: String) -> T {
        guard let filePath = Bundle.main.path(forResource: plistName, ofType: "plist") else {
            fatalError("Failed to find APIKeys.plist")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: value) as? T else {
            fatalError("Couldn't find key '\(value)' in '\(plistName).plist'.")
        }
        
        return value
    }
}

//
//  APIConfig.swift
//  Vault
//
//  Created by Austin Vesich on 7/12/24.
//

import Foundation

struct APIConfig {
    var apiURL: URL?
    var apiKey: String?
    
    init(configFileName: String) {
        guard let filePath = Bundle.main.path(forResource: configFileName, ofType: "plist") else {
            fatalError("Failed to find \(configFileName).plist")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        
        if let apiURLString = plist?.object(forKey: "ApiURL") as? String {
            apiURL = URL(string: apiURLString)
        }
        
        if let apiKeyString = plist?.object(forKey: "ApiKey") as? String {
            apiKey = apiKeyString
        }
    }
}

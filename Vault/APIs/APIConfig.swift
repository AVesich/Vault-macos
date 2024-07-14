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
        apiURL = URL(string: PlistHelper.get(value: "ApiUrl", from: configFileName))
        apiURL = PlistHelper.get(value: "ApiKey", from: configFileName)
    }
}

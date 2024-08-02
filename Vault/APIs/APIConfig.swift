//
//  APIConfig.swift
//  Vault
//
//  Created by Austin Vesich on 7/12/24.
//

import Foundation

struct APIConfig {
    let API_URL: URL?
    let API_KEY: String?
    let RESULTS_PER_PAGE: Int
    let MAX_PAGE_COUNT: Int
    
    init(configFileName: String, apiHasURL: Bool = false, apiNeedsKey: Bool = false) {
        API_URL = apiHasURL ? URL(string: PlistHelper.get(value: "API_URL", from: configFileName)) : nil
        RESULTS_PER_PAGE = PlistHelper.get(value: "RESULTS_PER_PAGE", from: configFileName)
        MAX_PAGE_COUNT = PlistHelper.get(value: "MAX_PAGE_COUNT", from: configFileName)
        API_KEY = apiNeedsKey ? PlistHelper.get(value: "API_KEY", from: configFileName) : nil
    }
}

//
//  APIJSONHelpers.swift
//  Vault
//
//  Created by Austin Vesich on 6/9/24.
//

import Foundation

struct APIJSONHelpers {
    public static func getURLRequest(withURLString urlString: String, andParams params: Dictionary<String, String>) -> URLRequest? {
        if let components = NSURLComponents(string: urlString) {
            for param in params {
                components.queryItems?.append(URLQueryItem(name: param.key, value: param.value))
            }
            
            if let completeURL = components.url {
                return URLRequest(url: completeURL)
            }
        }
        
        return nil
    }
}

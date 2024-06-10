//
//  APIJSONHelpers.swift
//  Vault
//
//  Created by Austin Vesich on 6/9/24.
//

import Foundation

struct APIJSONHelpers {
    public static func addHeadersToURLRequest(_ request: inout URLRequest, headers: Dictionary<String, String>) {
        for header in headers {
            if header.value == "Authorization" {
                request.setValue(header.value, forHTTPHeaderField: "Authorization")
            } else {
                request.addValue(header.value, forHTTPHeaderField: header.key)
            }
        }
    }
}

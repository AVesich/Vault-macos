//
//  URLUtil.swift
//  Vault
//
//  Created by Austin Vesich on 7/7/24.
//

import Foundation

struct URLUtil {
    public static func getURLToOpen(fromString urlString: String) -> URL? {
        if !stringStartsWithHTTP(urlString) && stringMatchesURLRegex(urlString) {
            return URL(string: "https://"+urlString)
        }
        if !stringStartsWithHTTP(urlString) && !stringMatchesURLRegex(urlString) {
            return URL(string: "https://www.google.com/search?q="+urlString)
        }
        return URL(string: urlString) // If url starts with http, take the user's word for it and try to search
    }
    
    private static func stringStartsWithHTTP(_ urlString: String) -> Bool {
        if let HTTP_REGEX = try? Regex("http(s)?"),
           urlString.starts(with: HTTP_REGEX) {
            return true
        }
        return false
    }
    
    private static func stringMatchesURLRegex(_ urlString: String) -> Bool {
        if let URL_REGEX = try? Regex("[(http(s)?):\\/\\/(www\\.)?a-zA-Z0-9@:%._\\+~#=]{2,256}\\.[a-z]{2,6}\\b([-a-zA-Z0-9@:%_\\+.~#?&//=]*)"),
            !urlString.matches(of: URL_REGEX).isEmpty {
            return true
        }
        return false
    }
}

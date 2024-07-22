//
//  String+URLUtils.swift
//  Vault
//
//  Created by Austin Vesich on 7/21/24.
//

import Foundation

extension String {
    public func asOpenableURL() -> URL? {
        let HTTPS = "https://"
        let GOOGLE_QUERY = "https://www.google.com/search?q="
        if !self.stringStartsWithHTTP() && self.isWebURL() {
            return URL(string: HTTPS+self)
        }
        if !self.stringStartsWithHTTP() && !self.isWebURL() {
            return URL(string: GOOGLE_QUERY+self)
        }
        return URL(string: self) // If url starts with http, take the user's word for it and try to search
    }
    
    public func stringStartsWithHTTP() -> Bool {
        if let HTTP_REGEX = try? Regex("http(s)?"),
           self.starts(with: HTTP_REGEX) {
            return true
        }
        return false
    }
    
    public func isWebURL() -> Bool {
        if let URL_REGEX = try? Regex("[(http(s)?):\\/\\/(www\\.)?a-zA-Z0-9@:%._\\+~#=]{2,256}\\.[a-z]{2,6}\\b([-a-zA-Z0-9@:%_\\+.~#?&//=]*)"),
           !self.matches(of: URL_REGEX).isEmpty {
            return true
        }
        return false
    }
    
    public func getImageDataFromSelfAsURL() async -> Data? {
        if let url = URL(string: self),
           let (data, _) = try? await URLSession.shared.data(from: url) {
            return data
        }
        return nil
    }
}

//
//  DirectorySearch.swift
//  Vault
//
//  Created by Austin Vesich on 5/18/24.
//

import Foundation

struct DirectorySearch {
    public func getDirectoryPaths(fromSearch searchedPath: String) {
        if let currentDirectoryURL = URL(string: searchedPath) {
            let childrenDirectories = try? FileManager.default.contentsOfDirectory(at: currentDirectoryURL,
                                                                                   includingPropertiesForKeys: [.isDirectoryKey],
                                                                                   options: [.skipsHiddenFiles]) ?? [URL]()
            print(childrenDirectories)
        }
    }
}

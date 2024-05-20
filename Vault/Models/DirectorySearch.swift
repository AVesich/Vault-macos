//
//  DirectorySearch.swift
//  Vault
//
//  Created by Austin Vesich on 5/18/24.
//

import Foundation

struct DirectorySearch {
    
    public func getSuggestedDirectory(forDirectorySearch typedPath: String) -> [String] {
        let pathResultURLs = getDirectoryPathResults(forPath: typedPath)
        let pathResultStrings = pathResultURLs.map { $0.relativePath }
        let pathEndParts = pathResultStrings.compactMap { $0.components(separatedBy: "/").last }
                
        print(pathEndParts)

        return pathEndParts
    }
    
    private func getDirectoryPathResults(forPath path: String) -> [URL] {
        if (path.count <= 0) {
            return [URL]()
        }
        if getDirectoryPaths(fromPath: path).isEmpty {
            let lastSlashIndex = path.lastIndex(of: "/") ?? path.startIndex
            let prevPath = path[path.startIndex...lastSlashIndex]
            return getDirectoryPaths(fromPath: String(prevPath))
        }
        return getDirectoryPaths(fromPath: path)
    }
    
    private func getDirectoryPaths(fromPath path: String) -> [URL] {
        if let currentDirectoryURL = URL(string: path) {
            let childrenDirectories = try? FileManager.default.contentsOfDirectory(at: currentDirectoryURL,
                                                                                   includingPropertiesForKeys: [.isDirectoryKey],
                                                                                   options: [.skipsHiddenFiles])
            return childrenDirectories ?? [URL]()
        }
        return [URL]()
    }
}

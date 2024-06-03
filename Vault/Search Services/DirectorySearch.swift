//
//  DirectorySearch.swift
//  Vault
//
//  Created by Austin Vesich on 5/18/24.
//

import Foundation

@Observable class DirectorySearch {
    
    // MARK: - Properties
    public var currentPrompt: String = "" {
        didSet {
            suggestedDirectory = getSuggestedDirectory(forDirectorySearch: currentPrompt)
        }
    }
    public var suggestedDirectory: String = ""
    
    // MARK: - Methods
    public func autofilledCurrentQuery() -> String {
        return currentPrompt.largestCompleteFilePath() + suggestedDirectory
    }
    
    private func getSuggestedDirectory(forDirectorySearch typedPath: String) -> String {
        guard let typedPathEnd = typedPath.components(separatedBy: "/").last else {
            return ""
        }
        let possiblePaths = getAllPossibleDirectoryPathHeads(forDirectorySearch: typedPath)
        var indexScorePairs = possiblePaths.enumerated().map { ($0.offset, typedPathEnd.similarity(to: $0.element)) }
        indexScorePairs.sort { $0.1 < $1.1 }
        
        if let closestMatchIndex = indexScorePairs.first?.0 {
            return possiblePaths[closestMatchIndex] + "/"
        }
        return ""
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
    
    private func getAllPossibleDirectoryPathHeads(forDirectorySearch typedPath: String) -> [String] {
        let pathResultURLs = getDirectoryPathResults(forPath: typedPath)
        let pathResultStrings = pathResultURLs.map { $0.relativePath }
        let pathEndParts = pathResultStrings.compactMap { $0.components(separatedBy: "/").last }
                
        return pathEndParts
    }
}

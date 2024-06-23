//
//  DirectorySearch.swift
//  Vault
//
//  Created by Austin Vesich on 5/18/24.
//

import Foundation
import SwiftUI

@Observable class DirectorySearch {
    
    // MARK: - Properties
//    private var queryTextString: String = "" {
//        didSet {
//            updateSuggestedDirectories()
//        }
//    }
    public var queryText: Binding<String>!
    public var suggestedDirectories = [URL]()
    private var suggestedDirectory: URL? {
        if let firstSuggestion = suggestedDirectories.first {
            return firstSuggestion
        }
        return nil
    }
    
    // MARK: - Methods
    public func autofillCurrentQuery() {
        if let suggestedDirectory {
            let completingNewPathComponent = queryText.wrappedValue.lastFilePathComponent().first != suggestedDirectory.lastPathComponent.first
            if completingNewPathComponent {
                queryText.wrappedValue = queryText.wrappedValue.last=="/" ? queryText.wrappedValue : queryText.wrappedValue+"/"
            }
            queryText.wrappedValue = queryText.wrappedValue.largestCompleteFilePath() + suggestedDirectory.lastPathComponent + "/"
        }
    }
    
    public func updateSuggestedDirectories() {
        guard let queryTrailingPathComponent = queryText.wrappedValue.components(separatedBy: "/").last else {
            return
        }
        
        let possiblePathURLs = getPossiblePathURLs(fromCurrentPath: queryText.wrappedValue)
        let sortedIndexURLPairs = possiblePathURLs.enumerated().sorted {
            let endPathComponentFirst = $0.element.lastPathComponent
            let endPathComponentSecond = $1.element.lastPathComponent
            
            return endPathComponentFirst.similarity(to: queryTrailingPathComponent)
                   <
                   endPathComponentSecond.similarity(to: queryTrailingPathComponent)
        }
        
        suggestedDirectories = sortedIndexURLPairs.map { $0.element }
    }
    
    private func getPossiblePathURLs(fromCurrentPath currentPath: String) -> [URL] {
        guard let currentPathURL = URL(string: currentPath) else {
            return [URL]()
        }
        
        return (try? FileManager.default.contentsOfDirectory(at: currentPathURL,
                                                             includingPropertiesForKeys: [.isDirectoryKey],
                                                             options: [.skipsHiddenFiles]))
                                                             ??
                                                             [URL]()
    }
        
//    private func getSuggestedDirectories(forDirectorySearch typedPath: String) -> [String] {
//        guard let typedPathEnd = typedPath.components(separatedBy: "/").last else {
//            return ""
//        }
//        let possiblePaths = getAllPossibleDirectoryPathHeads(forDirectorySearch: typedPath)
//        var indexScorePairs = possiblePaths.enumerated().map { ($0.offset, typedPathEnd.similarity(to: $0.element)) }
//        indexScorePairs.sort { $0.1 < $1.1 }
//        
//        return indexScorePairs.map { possiblePaths[$0] }
//    }
//    
//    private func getDirectoryPathResults(forPath path: String) -> [URL] {
//        if (path.count <= 0) {
//            return [URL]()
//        }
//        if getDirectoryPaths(fromPath: path).isEmpty {
//            let lastSlashIndex = path.lastIndex(of: "/") ?? path.startIndex
//            let prevPath = path[path.startIndex...lastSlashIndex]
//            return getDirectoryPaths(fromPath: String(prevPath))
//        }
//        return getDirectoryPaths(fromPath: path)
//    }
//    
//    private func getDirectoryPaths(fromPath path: String) -> [URL] {
//        if let currentDirectoryURL = URL(string: path) {
//            let childrenDirectories = try? FileManager.default.contentsOfDirectory(at: currentDirectoryURL,
//                                                                                   includingPropertiesForKeys: [.isDirectoryKey],
//                                                                                   options: [.skipsHiddenFiles])
//            return childrenDirectories ?? [URL]()
//        }
//        return [URL]()
//    }
//    
//    private func getAllPossibleDirectoryPathHeads(forDirectorySearch typedPath: String) -> [String] {
//        let pathResultURLs = getDirectoryPathResults(forPath: typedPath)
//        let pathResultStrings = pathResultURLs.map { $0.relativePath }
//        let pathEndParts = pathResultStrings.compactMap { $0.components(separatedBy: "/").last }
//                
//        return pathEndParts
//    }
}

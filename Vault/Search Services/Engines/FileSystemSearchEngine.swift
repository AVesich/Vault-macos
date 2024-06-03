//
//  FileSystemSearchEngine.swift
//  Vault
//
//  Created by Austin Vesich on 6/2/24.
//

import Foundation

struct FileSystemSearchEngine: Engine {
    
    // MARK: - Properties
    internal var activeDirectory: String
    private let MAX_RESULTS = 5
    
    // MARK: - Initialization
    init(activeDirectory: String) {
        self.activeDirectory = activeDirectory
    }
    
    // MARK: - Methods
    public func search(withQuery queryString: String) async -> [SearchResult] {
        return await searchFileSystem(withQuery: queryString)
    }
    
    private func searchFileSystem(withQuery queryString: String) async -> [SearchResult] {
        if let filePaths = getAllFilePathsFromActiveDirectory() {
            let recommendedFilePaths = await getRecommendedFilePaths(withQuery: queryString, outOfAllPaths: filePaths)
            return recommendedFilePaths.map { SearchResult(filePath: $0) }
        }
    
        return [SearchResult]()
    }
    
    private func getAllFilePathsFromActiveDirectory() -> [URL]? {
        let largestFilePath = activeDirectory.largestCompleteFilePath()
        if let filePathURL = URL(string: largestFilePath) {
            let filePathEnumerator = FileManager.default.enumerator(at: filePathURL,
                                                                    includingPropertiesForKeys: [.isReadableKey],
                                                                    options: .skipsHiddenFiles)
            return filePathEnumerator?.allObjects as? [URL]
        }
        return nil
    }
    
    private func getRecommendedFilePaths(withQuery queryString: String, outOfAllPaths allFilePaths: [URL]) async -> [URL] {
        var indexScorePairs = allFilePaths.enumerated().map { ($0.offset, queryString.similarity(to: $0.element.lastPathComponent)) }
        indexScorePairs.sort { $0.1 < $1.1 }
        let lastIndex = indexScorePairs.index(indexScorePairs.startIndex, offsetBy: min(MAX_RESULTS, indexScorePairs.count))
        let top5Paths = indexScorePairs[..<lastIndex].map { allFilePaths[$0.0] }
        return top5Paths
    }
}

//
//  FileSystemSearchEngine.swift
//  Vault
//
//  Created by Austin Vesich on 6/2/24.
//

import Foundation
import CoreSpotlight

class FileSystemSearchEngine: Engine {
    
    // MARK: - Properties
    private var query = NSMetadataQuery()
    private let MAX_RESULTS = 5
    
    deinit {
        print("Deinit fs search engine")
    }
    
    // MARK: - Methods
    public func search(withQuery queryString: String, inActiveDirectory activeDirectory: String) async -> [SearchResult] {
        indexedFileSearch(withQuery: queryString, inActiveDirectory: activeDirectory)
        return [SearchResult]()
//        return await searchFileSystem(withQuery: queryString)
    }
    
    private func searchFileSystem(withQuery queryString: String, inActiveDirectory activeDirectory: String) async -> [SearchResult] {
        if let filePaths = getAllFilePathsFromActiveDirectory(activeDirectory) {
            print(filePaths)
            let recommendedFilePaths = await getRecommendedFilePaths(withQuery: queryString, outOfAllPaths: filePaths)
            return recommendedFilePaths.map { SearchResult(filePath: $0) }
        }
    
        return [SearchResult]()
    }
    
    private func getAllFilePathsFromActiveDirectory(_ activeDirectory: String) -> [URL]? {
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
    
    
    
    private var queryResults = [CSSearchableItem]()

    private func indexedFileSearch(withQuery queryString: String, inActiveDirectory activeDirectory: String) {
        query.searchScopes = [NSMetadataQueryUserHomeScope]
        query.predicate = NSPredicate(format: "%K ==[cd] '*'", NSMetadataItemFSNameKey)
        query.operationQueue = OperationQueue.current
    
        NotificationCenter.default.addObserver(self, selector: #selector(handleQueryNotification1), name: NSNotification.Name.NSMetadataQueryDidStartGathering, object: query)
        NotificationCenter.default.addObserver(self, selector: #selector(handleQueryNotification2), name: NSNotification.Name.NSMetadataQueryDidFinishGathering, object: query)
        NotificationCenter.default.addObserver(self, selector: #selector(handleQueryNotification3), name: NSNotification.Name.NSMetadataQueryDidUpdate, object: query)

        query.enableUpdates()
        
        DispatchQueue.main.sync {
            query.start()
        }
    }
    
    @objc func handleQueryNotification1() {
        print("start")
        print(query.results)
    }

    @objc func handleQueryNotification2() {
        print("finish")
        print(query.results)
        query.stop()
    }

    @objc func handleQueryNotification3() {
        print("update")
        print(query.results)
    }
}

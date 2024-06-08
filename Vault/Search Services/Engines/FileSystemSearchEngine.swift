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
    public var delegate: EngineDelegate?
    internal var searchResults = [SearchResult]()
    private var query = NSMetadataQuery()
    private let MAX_RESULTS = 5
    
    init() {
        oneTimeQueryConfig()
        oneTimeQueryNotificationSetup()
    }
    
    deinit {
        query.disableUpdates()
    }
    
    // MARK: - Methods
    private func oneTimeQueryConfig() {
        query.operationQueue = OperationQueue.current
        query.enableUpdates()
    }
    
    private func oneTimeQueryNotificationSetup() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleQueryStartNotification), name: NSNotification.Name.NSMetadataQueryDidStartGathering, object: query)
        NotificationCenter.default.addObserver(self, selector: #selector(handleQueryGatheringNotification), name: NSNotification.Name.NSMetadataQueryDidFinishGathering, object: query)
        NotificationCenter.default.addObserver(self, selector: #selector(handleQueryFinishNotification), name: NSNotification.Name.NSMetadataQueryGatheringProgress, object: query)
    }
    
    public func search(withQuery queryString: String, inActiveDirectory activeDirectory: String) async {
        indexedFileSearch(withQuery: queryString, inActiveDirectory: activeDirectory)
    }

    private func indexedFileSearch(withQuery queryString: String, inActiveDirectory activeDirectory: String) {
        // Display names are indexed by MacOS, this key must be used for the fastest search times
        query.predicate = NSPredicate(format: "%K CONTAINS[cd] %@", argumentArray: [NSMetadataItemDisplayNameKey, queryString])
        query.searchScopes = [NSString(string: activeDirectory)]
        DispatchQueue.main.sync {
            query.start()
        }
    }
    
    @objc func handleQueryStartNotification() {
        print("start")
    }
    
    @objc func handleQueryGatheringNotification() {
        print("gathering")
        print(query.results)
    }

    @objc func handleQueryFinishNotification() {
        print("finish")
        if let resultMetadata = query.results as? [NSMetadataItem] {
            let trimmedResults = getSearchResults(fromMetadata: resultMetadata).trimmed(toLength: MAX_RESULTS)
            delegate?.engineDidFindResults(results: trimmedResults)
        }
        query.stop()
    }
    
    private func getSearchResults(fromMetadata metadata: [NSMetadataItem]) -> [SearchResult] {
        let fileURLs: [URL] = metadata.compactMap {
            if let pathString = $0.value(forKey: NSMetadataItemPathKey) as? String {
                return URL(string: pathString)
            }
            return nil
        }
        
        return fileURLs.map { SearchResult(filePath: $0) }
    }
}

protocol FileSystemSearchEngineDelegate: EngineDelegate {}

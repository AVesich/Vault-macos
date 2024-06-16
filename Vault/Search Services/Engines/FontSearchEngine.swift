//
//  File.swift
//  Vault
//
//  Created by Austin Vesich on 6/14/24.
//

import Foundation
import AppKit

// Uses the same code as FileSystemSearchEngine, but adds additional file extension comparison
class FontSearchEngine: Engine {
    
    // MARK: - Declaring properties
    public var delegate: EngineDelegate?
    internal var searchResults = [SearchResult]()
    private var query = NSMetadataQuery()
    private let MAX_RESULTS = 15
    private let FILE_PREFIX = "File://"
    private let FONT_FILE_ENDINGS = [".ttf", ".otf"]
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(handleQueryGatheringNotification), name: NSNotification.Name.NSMetadataQueryDidFinishGathering, object: query)
        NotificationCenter.default.addObserver(self, selector: #selector(handleQueryFinishNotification), name: NSNotification.Name.NSMetadataQueryGatheringProgress, object: query)
    }
    
    public func search(withQuery query: String, inActiveDirectory activeDirectory: String) async {
        indexedFontSearch(withQuery: query)
    }

    private func indexedFontSearch(withQuery query: String) {
        // Display names are indexed by MacOS, this key must be used for the fastest search times
        let containsPredicate = NSPredicate(format: "%K CONTAINS[cd] %@", argumentArray: [NSMetadataItemDisplayNameKey, query])
//        let fileExtensionPredicate = NSPredicate(format: "pathExtension IN %@", argumentArray: [FONT_FILE_ENDINGS])
        let fileExtensionPredicate = NSPredicate(format: "%K ENDSWITH[cd] %@", argumentArray: [NSMetadataItemFSNameKey, ".ttf"])
        self.query.predicate = fileExtensionPredicate//NSCompoundPredicate(andPredicateWithSubpredicates: [containsPredicate, fileExtensionPredicate])
        self.query.searchScopes = [NSString(string: FileManager.default.homeDirectoryForCurrentUser.relativePath)]
        DispatchQueue.main.sync {
            self.query.start()
        }
    }
    
    @objc func handleQueryGatheringNotification() {
        print("gathering")
//        print(query.results)
    }

    @objc func handleQueryFinishNotification() {
        print("finish")
        print(query.results)
        if let resultMetadata = query.results as? [NSMetadataItem] {
            let trimmedResults = getSearchResults(fromMetadata: resultMetadata).trimmed(toLength: MAX_RESULTS)
            delegate?.engineDidFindResults(results: trimmedResults)
        }
        query.stop()
    }
    
    private func getSearchResults(fromMetadata metadata: [NSMetadataItem]) -> [SearchResult] {
        var results = [SearchResult]()
        
        let fileURLs: [URL] = metadata.compactMap {
            if let pathString = $0.value(forKey: NSMetadataItemPathKey) as? String {
                if let fileURL = URL(string: FILE_PREFIX+pathString) {
                    print(try? Data(contentsOf: fileURL))
                    if let font = try? Data(contentsOf: fileURL) as? NSFont {
                        print(font.familyName)
                        // results.append( SearchResult(font: font) )
                    }
                }
                return URL(string: FILE_PREFIX+pathString)
            }
            return nil
        }
        
        return fileURLs.map { SearchResult(filePath: $0) }
    }
}

protocol FontSearchEngineDelegate: EngineDelegate {}

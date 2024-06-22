//
//  File.swift
//  Vault
//
//  Created by Austin Vesich on 6/14/24.
//

import Foundation
import AppKit
import SwiftUI

// Uses the same code as FileSystemSearchEngine, but adds additional file extension comparison
class FontSearchEngine: Engine {
    
    // MARK: - Declaring properties
    public var delegate: EngineDelegate?
    internal var searchResults = [SearchResult]()
    private var userQuery = NSMetadataQuery()
    private var systemQuery = NSMetadataQuery()
    private let MAX_RESULTS = 15
    private let FONT_PATH_FROM_USER = "/Library/Fonts/"
    private let FONT_FILE_ENDINGS = [".ttf", ".otf"]
    private var fontExtensionPredicate: NSPredicate {
        var extensionPredicates = [NSPredicate]()
        for fileExtension in FONT_FILE_ENDINGS {
            let predicate = NSPredicate(format: "%K ENDSWITH[c] %@", argumentArray: [NSMetadataItemFSNameKey, fileExtension])
            extensionPredicates.append(predicate)
        }
        let combinedPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: extensionPredicates)
        return combinedPredicate
    }
    
    init() {
        oneTimeQueryConfig()
        oneTimeQueryNotificationSetup()
    }
    
    deinit {
        disableQueryUpdates()
    }
    
    // MARK: - Methods
    private func oneTimeQueryConfig() {
        userQuery.searchScopes = [NSString(string: FileManager.default.homeDirectoryForCurrentUser.relativePath+FONT_PATH_FROM_USER)]
        userQuery.operationQueue = OperationQueue.current
        userQuery.enableUpdates()
        
        systemQuery.searchScopes = [NSString(string: "/System/"+FONT_PATH_FROM_USER)]
        systemQuery.operationQueue = OperationQueue.current
        systemQuery.enableUpdates()
    }
    
    private func disableQueryUpdates() {
        userQuery.disableUpdates()
        systemQuery.disableUpdates()
    }
    
    private func oneTimeQueryNotificationSetup() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserQueryFinishNotification), name: NSNotification.Name.NSMetadataQueryGatheringProgress, object: userQuery)
        NotificationCenter.default.addObserver(self, selector: #selector(handleSystemQueryFinishNotification), name: NSNotification.Name.NSMetadataQueryGatheringProgress, object: systemQuery)
    }
    
    public func search(withQuery query: String, inActiveDirectory activeDirectory: String) {
        indexedFontSearch(withQuery: query)
    }

    private func indexedFontSearch(withQuery query: String) {
        searchResults.removeAll()
        
        // Display names are indexed by MacOS, this key must be used for the fastest search times
        let containsPredicate = NSPredicate(format: "%K CONTAINS[cd] %@", argumentArray: [NSMetadataItemDisplayNameKey, query])
        let extensionContainsPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fontExtensionPredicate, containsPredicate])
        userQuery.predicate = extensionContainsPredicate
        self.userQuery.start()
        systemQuery.predicate = extensionContainsPredicate
        self.systemQuery.start()
    }
    
    @objc func handleUserQueryFinishNotification() {
        print("User finish")
        if let resultMetadata = userQuery.results as? [NSMetadataItem] {
            updateSearchResults(fromMetadata: resultMetadata)
            delegate?.engineDidFindResults(results: searchResults)
        }
        userQuery.stop()
    }
    
    @objc func handleSystemQueryFinishNotification() {
        print("System finish")
        if let resultMetadata = systemQuery.results as? [NSMetadataItem] {
            updateSearchResults(fromMetadata: resultMetadata)
            delegate?.engineDidFindResults(results: searchResults)
        }
        systemQuery.stop()
    }
    
    private func updateSearchResults(fromMetadata metadata: [NSMetadataItem]) {
        /*
         Font metadata results seem to be arrays made of 3 components:
         [0]:   Font family name (Example: Arial)
         [1]:   Actual font name (Example: Arial-Regular)
         [2]:   Font style       (Examples: Regular, Bold, etc.)
         */
        for data in metadata {
//            if searchResults.count >= MAX_RESULTS {
//                break
//            }
            if let fontData = data.value(forKey: NSMetadataItemFontsKey) as? [String] {
                if fontData.count >= 2 {
                    if let font = NSFont(name: fontData[1], size: 24.0) {
                        searchResults.append(SearchResult(font: font))
                    }
               }
            }
        }
    }
}

protocol FontSearchEngineDelegate: EngineDelegate {}

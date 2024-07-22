//
//  File.swift
//  Vault
//
//  Created by Austin Vesich on 7/20/24.
//

import Foundation

final class FileSystemAPI: API {
    // MARK: - Properties
    internal var apiConfig: APIConfig!
    internal var results = [any SearchResult]()
    internal var prevQuery: String? = nil
    internal var nextPageInfo: NextPageInfo = NextPageInfo<Int>(nextPageCursor: nil, hasNextPage: true)
    internal var isLoadingNewPage: Bool = false
    private var query = NSMetadataQuery()
    private let FILE_PREFIX = "File://"
    private var activeDirectory: String = FileManager.default.homeDirectoryForCurrentUser.relativePath
    private var queryContinuation: CheckedContinuation<APIResponse<Int>, Never>? // This is used to make fetching results with a callback/notification-based system perform like it's async
    
    // MARK: - Initialization
    init() {
        oneTimeQueryConfig()
        oneTimeQueryNotificationSetup()
    }
    
    deinit {
        queryContinuation?.resume(returning: APIResponse(results: [FileResult](), nextPageInfo: NextPageInfo(nextPageCursor: nil, hasNextPage: false))) // Resume if we haven't resumed before deinit
        queryContinuation = nil
        query.disableUpdates()
    }
    
    internal func postInitSetup() { }
        
    // MARK: - Methods
    private func oneTimeQueryConfig() {
        query.operationQueue = OperationQueue.current
        query.enableUpdates()
    }
    
    private func oneTimeQueryNotificationSetup() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleQueryGatheringNotification), name: NSNotification.Name.NSMetadataQueryDidFinishGathering, object: query)
        NotificationCenter.default.addObserver(self, selector: #selector(handleQueryFinishNotification), name: NSNotification.Name.NSMetadataQueryGatheringProgress, object: query)
    }
    
    internal func getResultData(for query: String) async -> APIResponse<Int> {
        isLoadingNewPage = true
        defer {
            isLoadingNewPage = false
        }
        
        // Display names are indexed by MacOS, this key must be used for the fastest search times
        self.query.predicate = NSPredicate(format: "%K CONTAINS[cd] %@", argumentArray: [NSMetadataItemDisplayNameKey, query])
        self.query.searchScopes = [NSString(string: activeDirectory)]
        
//        queryContinuation?.resume(returning: [FileResult]())
        let apiResult = await withCheckedContinuation { continuation in // Continuation is resumed in query finding results notification
            queryContinuation = continuation
            self.query.start()
        }
        
        queryContinuation = nil
        return apiResult
    }
    
    private func getSearchResults(fromMetadata metadata: [NSMetadataItem]) -> [FileResult] {
        var results = [FileResult]()
        
        for data in metadata {
            if let pathString = data.value(forKey: NSMetadataItemPathKey) as? String,
               let fileURL = URL(string: FILE_PREFIX+pathString) {
                results.append(FileResult(content: fileURL))
            }
        }
        
        return results
    }
    
    // MARK: - Notif handlers
    @objc func handleQueryGatheringNotification() {
        print("gathering")
    }

    @objc func handleQueryFinishNotification() {
        print("finish")
        
        var pageResults = [FileResult]()
        let startingIndexInt = nextPageInfo.nextPageCursor ?? 0 // Cursor isn't updated yet, so next cursor is start
        let endIndexInt = startingIndexInt+apiConfig.RESULTS_PER_PAGE

        if let resultMetadata = query.results as? [NSMetadataItem] {
            pageResults = getSearchResults(fromMetadata: resultMetadata)
            let startingIndex = pageResults.index(pageResults.startIndex, offsetBy: startingIndexInt)
            let endingIndex = pageResults.index(pageResults.startIndex, offsetBy: endIndexInt)
            pageResults = Array(pageResults[startingIndex..<endingIndex])
        }
        
        let hasResultsAvailable = endIndexInt < apiConfig.MAX_RESULTS
        let nextPageInfo = NextPageInfo(nextPageCursor: endIndexInt, hasNextPage: hasResultsAvailable)
        
        // Stop our query & end async search function continuation
        query.stop()
        queryContinuation?.resume(returning: APIResponse(results: pageResults, nextPageInfo: nextPageInfo))
    }
}

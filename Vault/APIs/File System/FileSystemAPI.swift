//
//  File.swift
//  Vault
//
//  Created by Austin Vesich on 7/20/24.
//

import Foundation

final class FileSystemAPI: LocalAPI {
    
    // MARK: - Properties
    internal var isReset: Bool = false
    internal var apiConfig: APIConfig!
    internal var prevQuery: String? = nil
    internal var nextPageInfo: NextPageInfo = NextPageInfo<Int>(nextPageCursor: nil, hasNextPage: true)
    internal var isLoadingNewPage: Bool = false
    internal var loadedPageCount: Int = 0
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
    
    internal func getResultData(forQuery query: String) async -> APIResponse<Int> {
        isLoadingNewPage = true
        defer {
            isLoadingNewPage = false
        }
        guard nextPageInfo.hasNextPage else {
            return APIResponse(results: [FileResult](), nextPageInfo: nextPageInfo)
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
        var pageInfo: NextPageInfo<Int> = nextPageInfo // If we get no metadata results, we will use the existing page info to allow a search retry to or continue enging pagination

        if let resultMetadata = query.results as? [NSMetadataItem] {
            loadedPageCount += 1
            pageResults = getSearchResults(fromMetadata: resultMetadata)
            pageInfo = concatResultsAndGetPageInfo(foundResults: &pageResults)
        }
                
        // Stop our query & end async search function continuation
        query.stop()
        queryContinuation?.resume(returning: APIResponse(results: pageResults, nextPageInfo: pageInfo))
    }
}

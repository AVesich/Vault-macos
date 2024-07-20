//
//  File.swift
//  Vault
//
//  Created by Austin Vesich on 7/20/24.
//

final class FileSystemAPI: API {
    // MARK: - Properties
    internal var apiConfig: APIConfig!
    internal var results = [any SearchResult]()
    internal var prevQuery: String? = nil
    internal var nextPageInfo: NextPageInfo = NextPageInfo<Int>(nextPageCursor: nil, hasNextPage: true)
    internal var isLoadingNewPage: Bool = false
    
    // MARK: - Methods
    internal func getResultData(for query: String) async -> (results: [any SearchResult], nextPageInfo: NextPageInfo<Int>) {
        var fetchedResults = [any SearchResult]()
        var fetchedNextPageInfo = NextPageInfo<Int>(nextPageCursor: nil, hasNextPage: false)
        isLoadingNewPage = true
        defer {
            isLoadingNewPage = false
        }
//        
//        guard let graphQLClient, (results.isEmpty || nextPageInfo.hasNextPage) else {
//            return (fetchedResults, fetchedNextPageInfo)
//        }
//        
//        do {
//            let resultData = try await currentMode.fetch(withGraphQLClient: graphQLClient, query: query, numResults: apiConfig.RESULTS_PER_PAGE, nextCursor: nextPageInfo.nextPageCursor)
//            fetchedResults = resultData.results
//            fetchedNextPageInfo = resultData.nextPageInfo
//        } catch {
//            print("Failed to fetch with error: \(error)")
//        }
        return (fetchedResults, fetchedNextPageInfo)
    }
}

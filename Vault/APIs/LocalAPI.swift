//
//  API.swift
//  Vault
//
//  Created by Austin Vesich on 7/12/24.
//

protocol LocalAPI: API where PageCursorType == Int {}

extension LocalAPI {
    func concatResultsAndGetPageInfo<ResultType: SearchResult>(foundResults: inout [ResultType]) -> NextPageInfo<Int> {
        let startingIndexInt = nextPageInfo.nextPageCursor ?? 0 // Cursor isn't updated yet, so next cursor is start
        var endIndexInt = startingIndexInt+apiConfig.RESULTS_PER_PAGE
        endIndexInt = (endIndexInt <= foundResults.count) ? endIndexInt : foundResults.count // Cap the end index at the number of total results if the page wants to include more results than available
        let startingIndex = foundResults.index(foundResults.startIndex, offsetBy: startingIndexInt)
        let endingIndex = foundResults.index(foundResults.startIndex, offsetBy: endIndexInt)
        foundResults = Array(foundResults[startingIndex..<endingIndex])
        
        let hasResultsAvailable = (loadedPageCount < apiConfig.MAX_PAGE_COUNT) && (endIndexInt != foundResults.count) // End < Max means that we actually limited results and end != count means we aren't result-count-limited
        return NextPageInfo(nextPageCursor: endIndexInt, hasNextPage: hasResultsAvailable)
    }
}

//
//  UnsplashAPI.swift
//  Vault
//
//  Created by Austin Vesich on 7/21/24.
//

import Foundation

final class UnsplashAPI: API {

    // MARK: - Properties
    internal var isReset: Bool = false
    internal var apiConfig: APIConfig!
    internal var prevQuery: String?
    internal var nextPageInfo: NextPageInfo<Int> = .init(nextPageCursor: nil, hasNextPage: true)
    internal var isLoadingNewPage: Bool = false
    internal var loadedPageCount: Int = 0
    private var searchParams: Dictionary<String, String>!
    
    // MARK: - Methods
    internal func postInitSetup() {
        guard let apiKey = apiConfig.API_KEY else {
            fatalError("Unsplash api key unavaliable in config files.")
        }
        searchParams = [
            "client_id" : apiConfig.API_KEY!,
            "page" : "1",
            "per_page" : String(apiConfig.RESULTS_PER_PAGE)
        ]
    }
    
    public func getResultData(forQuery query: String) async -> APIResponse<Int> {
        guard let apiURL = apiConfig.API_URL else {
            fatalError("Unsplash api url unavaliable in config files.")
        }
        guard nextPageInfo.hasNextPage else  {
            return APIResponse(results: [ImagesResult](), nextPageInfo: nextPageInfo)
        }
        
        var photoURLs = [PhotoURLs]()
//        do {
            if let (data, _) = try? await URLSession.shared.data(for: getSearchPhotosRequest(forURLString: apiURL.absoluteString+"/search/photos/?", withQuery: query)) {
                let decoder = APIDecoder<UnsplashPhotoSearchResult>()
                if let decodedResult = decoder.decodeValueFromData(data) {
                    photoURLs = getImagesURLsFromSearchResult(decodedResult)
                }
            }
//        } catch {
//            print(error)
//        }
        
        if !photoURLs.isEmpty {
            loadedPageCount += 1
            
            let result = ImagesResult(content: photoURLs)
            let nextPageCursor = (nextPageInfo.nextPageCursor ?? 1) + 1
            let hasNextPage = loadedPageCount < apiConfig.MAX_PAGE_COUNT

            return APIResponse(results: [result], nextPageInfo: NextPageInfo(nextPageCursor: nextPageCursor, hasNextPage: hasNextPage))
        }
        
        return APIResponse(results: [ImagesResult](), nextPageInfo: nextPageInfo)
    }
    
    private func getSearchPhotosRequest(forURLString urlString: String, withQuery query: String) -> URLRequest {
        searchParams["page"] = String((nextPageInfo.nextPageCursor ?? 1))
        searchParams["query"] = query
        if var request = APIJSONHelpers.getURLRequest(withURLString: urlString, andParams: searchParams) {
            request.httpMethod = "GET"
            return request
        } else {
            return URLRequest(url: URL(string: "")!)
        }
    }

    private func getImagesURLsFromSearchResult(_ searchResult: UnsplashPhotoSearchResult) -> [PhotoURLs] {
        let photoURLs: [PhotoURLs] = searchResult.results.map { result in
            return result.urls
        }
        
        return photoURLs
    }
}

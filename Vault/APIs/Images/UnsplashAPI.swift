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
    var apiConfig: APIConfig!
    var results = [any SearchResult]()
    var prevQuery: String?
    var nextPageInfo: NextPageInfo<Int> = .init(nextPageCursor: nil, hasNextPage: true) {
        didSet {
            if let nextPageNumber = nextPageInfo.nextPageCursor {
                searchParams["page"] = String(nextPageNumber)
            }
        }
    }
    var isLoadingNewPage: Bool = false
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
    
    public func getResultData(for query: String) async -> APIResponse<Int> {
        guard let apiURL = apiConfig.API_URL else {
            fatalError("Unsplash api url unavaliable in config files.")
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
            // Rare occurance that we touch the existing results. DON'T DO THIS NORMALLY.
            if let images = results.first?.content as? [PhotoURLs] {
                photoURLs.insert(contentsOf: images, at: 0) // We build the new page onto the end of the old page
                results.removeAll() // Remove the first result, as it is to be replaced with the new result (only 1 result with many images is shown for unsplash)
            }
            
            let result = ImagesResult(content: photoURLs)
            let nextPageCursor = (nextPageInfo.nextPageCursor ?? 0) + 1
            let hasNextPage = result.content.count < apiConfig.MAX_RESULTS

            return APIResponse(results: [result], nextPageInfo: NextPageInfo(nextPageCursor: nextPageCursor, hasNextPage: hasNextPage))
        }
        
        
        
        return APIResponse(results: [any SearchResult](), nextPageInfo: NextPageInfo(nextPageCursor: nextPageInfo.nextPageCursor, hasNextPage: true))
    }
    
    private func getSearchPhotosRequest(forURLString urlString: String, withQuery query: String) -> URLRequest {
        searchParams["query"] = query
        if var request = APIJSONHelpers.getURLRequest(withURLString: urlString, andParams: searchParams) {
            request.httpMethod = "GET"
            dump(request)
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

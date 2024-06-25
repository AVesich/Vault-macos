//
//  GithubSearchEngine.swift
//  Vault
//
//  Created by Austin Vesich on 6/24/24.
//

import Foundation

class GitHubSearchEngine: Engine {
    
    public var searchResults: [SearchResult] = [SearchResult]()
    internal var delegate: EngineDelegate?
    private let RESULTS_PER_PAGE = 15
    
    public func search(withQuery query: String, inActiveDirectory activeDirectory: String) {
        Task {
            await searchRepositories(withQuery: query)
            delegate?.engineDidFindResults(results: searchResults)
        }
    }
    
    private func searchRepositories(withQuery query: String) async {
        guard let searchRequest = getURLRequest(withQuery: query) else {
            return
        }
        if let (data, _) = try? await URLSession.shared.data(for: searchRequest) {
            let decoder = APIDecoder<GitHubRepoSearchWrapper>()
            if let result = decoder.decodeValueFromData(data) {
                searchResults = result.items.map {
                    SearchResult(gitHubRepoResult: $0)
                }
            }
        }
    }
    
    private func getURLRequest(withQuery query: String) -> URLRequest? {
        let params: [String: String] = [
            "q" : query,
            "per_page": "\(RESULTS_PER_PAGE)"
        ]
        return APIJSONHelpers.getURLRequest(withURLString: "https://api.github.com/search/repositories?",
                                            andParams: params)
    }
}

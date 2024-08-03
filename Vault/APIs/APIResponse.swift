//
//  APIResponse.swift
//  Vault
//
//  Created by Austin Vesich on 7/20/24.
//

struct APIResponse<CursorType> {
    let results: [any SearchResult]
    let nextPageInfo: NextPageInfo<CursorType>
}

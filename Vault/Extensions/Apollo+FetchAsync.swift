//
//  Apollo+FetchAsync.swift
//  Vault
//
//  Created by Austin Vesich on 7/13/24.
//

import Apollo
import ApolloAPI

extension ApolloClient {
    func fetchAsync<Query: GraphQLQuery>(query: Query) async throws -> GraphQLResult<Query.Data> {
        return try await withCheckedThrowingContinuation { continuation in
            fetch(query: query) { result in
                switch result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

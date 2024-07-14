//
//  AuthInterceptorProvider.swift
//  Vault
//
//  Created by Austin Vesich on 7/13/24.
//

import Apollo
import ApolloAPI

class AuthInterceptorProvider: DefaultInterceptorProvider {
    public var authToken: String!
    
    init(client: URLSessionClient, store: ApolloStore, authToken: String) {
        super.init(client: client, store: store)
        self.authToken = authToken
    }
    
    override func interceptors<Operation>(for operation: Operation) -> [any ApolloInterceptor] where Operation : GraphQLOperation {
        var interceptors = super.interceptors(for: operation)
        interceptors.insert(AuthInterceptor(authToken: authToken), at: 0)
        return interceptors
    }
}

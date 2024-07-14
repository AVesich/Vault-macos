//
//  AuthInterceptor.swift
//  Vault
//
//  Created by Austin Vesich on 7/13/24.
//

import Foundation
import Apollo
import ApolloAPI

class AuthInterceptor: ApolloInterceptor {
    public var id: String = UUID().uuidString
    public var authToken: String!
    
    init(authToken: String) {
        self.authToken = authToken
    }
    
    func interceptAsync<Operation>(chain: any RequestChain, 
                                   request: HTTPRequest<Operation>,
                                   response: HTTPResponse<Operation>?,
                                   completion: @escaping (Result<GraphQLResult<Operation.Data>, any Error>) -> Void) where Operation : GraphQLOperation {
        request.addHeader(name: "Authorization", value: "bearer " + authToken)
        chain.proceedAsync(request: request,
                           response: response,
                           interceptor: self,
                           completion: completion)
    }
}

// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class GitHubUserQuery: GraphQLQuery {
  public static let operationName: String = "GitHubUserQuery"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query GitHubUserQuery($query: String!, $numResults: Int!, $afterCursor: String) { search(type: USER, query: $query, first: $numResults, after: $afterCursor) { __typename users: edges { __typename user: node { __typename ... on User { login url avatarUrl } } } pageInfo { __typename endCursor hasNextPage } } }"#
    ))

  public var query: String
  public var numResults: Int
  public var afterCursor: GraphQLNullable<String>

  public init(
    query: String,
    numResults: Int,
    afterCursor: GraphQLNullable<String>
  ) {
    self.query = query
    self.numResults = numResults
    self.afterCursor = afterCursor
  }

  public var __variables: Variables? { [
    "query": query,
    "numResults": numResults,
    "afterCursor": afterCursor
  ] }

  public struct Data: GitHubAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { GitHubAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("search", Search.self, arguments: [
        "type": "USER",
        "query": .variable("query"),
        "first": .variable("numResults"),
        "after": .variable("afterCursor")
      ]),
    ] }

    /// Perform a search across resources, returning a maximum of 1,000 results.
    public var search: Search { __data["search"] }

    /// Search
    ///
    /// Parent Type: `SearchResultItemConnection`
    public struct Search: GitHubAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { GitHubAPI.Objects.SearchResultItemConnection }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("edges", alias: "users", [User?]?.self),
        .field("pageInfo", PageInfo.self),
      ] }

      /// A list of edges.
      public var users: [User?]? { __data["users"] }
      /// Information to aid in pagination.
      public var pageInfo: PageInfo { __data["pageInfo"] }

      /// Search.User
      ///
      /// Parent Type: `SearchResultItemEdge`
      public struct User: GitHubAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { GitHubAPI.Objects.SearchResultItemEdge }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("node", alias: "user", User?.self),
        ] }

        /// The item at the end of the edge.
        public var user: User? { __data["user"] }

        /// Search.User.User
        ///
        /// Parent Type: `SearchResultItem`
        public struct User: GitHubAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { GitHubAPI.Unions.SearchResultItem }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .inlineFragment(AsUser.self),
          ] }

          public var asUser: AsUser? { _asInlineFragment() }

          /// Search.User.User.AsUser
          ///
          /// Parent Type: `User`
          public struct AsUser: GitHubAPI.InlineFragment {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public typealias RootEntityType = GitHubUserQuery.Data.Search.User.User
            public static var __parentType: any ApolloAPI.ParentType { GitHubAPI.Objects.User }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("login", String.self),
              .field("url", GitHubAPI.URI.self),
              .field("avatarUrl", GitHubAPI.URI.self),
            ] }

            /// The username used to login.
            public var login: String { __data["login"] }
            /// The HTTP URL for this user
            public var url: GitHubAPI.URI { __data["url"] }
            /// A URL pointing to the user's public avatar.
            public var avatarUrl: GitHubAPI.URI { __data["avatarUrl"] }
          }
        }
      }

      /// Search.PageInfo
      ///
      /// Parent Type: `PageInfo`
      public struct PageInfo: GitHubAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { GitHubAPI.Objects.PageInfo }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("endCursor", String?.self),
          .field("hasNextPage", Bool.self),
        ] }

        /// When paginating forwards, the cursor to continue.
        public var endCursor: String? { __data["endCursor"] }
        /// When paginating forwards, are there more items?
        public var hasNextPage: Bool { __data["hasNextPage"] }
      }
    }
  }
}

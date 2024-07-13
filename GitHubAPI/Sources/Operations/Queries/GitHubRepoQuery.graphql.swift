// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class GitHubRepoQuery: GraphQLQuery {
  public static let operationName: String = "GitHubRepoQuery"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query GitHubRepoQuery($query: String!, $numResults: Int!, $afterCursor: String) { search(type: REPOSITORY, query: $query, first: $numResults, after: $afterCursor) { __typename repos: edges { __typename repo: node { __typename ... on Repository { url name owner { __typename avatarUrl } } } } pageInfo { __typename startCursor endCursor hasNextPage } } }"#
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
        "type": "REPOSITORY",
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
        .field("edges", alias: "repos", [Repo?]?.self),
        .field("pageInfo", PageInfo.self),
      ] }

      /// A list of edges.
      public var repos: [Repo?]? { __data["repos"] }
      /// Information to aid in pagination.
      public var pageInfo: PageInfo { __data["pageInfo"] }

      /// Search.Repo
      ///
      /// Parent Type: `SearchResultItemEdge`
      public struct Repo: GitHubAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { GitHubAPI.Objects.SearchResultItemEdge }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("node", alias: "repo", Repo?.self),
        ] }

        /// The item at the end of the edge.
        public var repo: Repo? { __data["repo"] }

        /// Search.Repo.Repo
        ///
        /// Parent Type: `SearchResultItem`
        public struct Repo: GitHubAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { GitHubAPI.Unions.SearchResultItem }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .inlineFragment(AsRepository.self),
          ] }

          public var asRepository: AsRepository? { _asInlineFragment() }

          /// Search.Repo.Repo.AsRepository
          ///
          /// Parent Type: `Repository`
          public struct AsRepository: GitHubAPI.InlineFragment {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public typealias RootEntityType = GitHubRepoQuery.Data.Search.Repo.Repo
            public static var __parentType: any ApolloAPI.ParentType { GitHubAPI.Objects.Repository }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("url", GitHubAPI.URI.self),
              .field("name", String.self),
              .field("owner", Owner.self),
            ] }

            /// The HTTP URL for this repository
            public var url: GitHubAPI.URI { __data["url"] }
            /// The name of the repository.
            public var name: String { __data["name"] }
            /// The User owner of the repository.
            public var owner: Owner { __data["owner"] }

            /// Search.Repo.Repo.AsRepository.Owner
            ///
            /// Parent Type: `RepositoryOwner`
            public struct Owner: GitHubAPI.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: any ApolloAPI.ParentType { GitHubAPI.Interfaces.RepositoryOwner }
              public static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("avatarUrl", GitHubAPI.URI.self),
              ] }

              /// A URL pointing to the owner's public avatar.
              public var avatarUrl: GitHubAPI.URI { __data["avatarUrl"] }
            }
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
          .field("startCursor", String?.self),
          .field("endCursor", String?.self),
          .field("hasNextPage", Bool.self),
        ] }

        /// When paginating backwards, the cursor to continue.
        public var startCursor: String? { __data["startCursor"] }
        /// When paginating forwards, the cursor to continue.
        public var endCursor: String? { __data["endCursor"] }
        /// When paginating forwards, are there more items?
        public var hasNextPage: Bool { __data["hasNextPage"] }
      }
    }
  }
}

// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class GitHubPRQuery: GraphQLQuery {
  public static let operationName: String = "GitHubPRQuery"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query GitHubPRQuery($numResults: Int!, $afterCursor: String) { viewer { __typename pullRequests(first: $numResults, after: $afterCursor) { __typename pullRequests: edges { __typename pullRequests: node { __typename author { __typename login url avatarUrl } closed merged title url baseRefName headRefName } } pageInfo { __typename endCursor hasNextPage } } } }"#
    ))

  public var numResults: Int
  public var afterCursor: GraphQLNullable<String>

  public init(
    numResults: Int,
    afterCursor: GraphQLNullable<String>
  ) {
    self.numResults = numResults
    self.afterCursor = afterCursor
  }

  public var __variables: Variables? { [
    "numResults": numResults,
    "afterCursor": afterCursor
  ] }

  public struct Data: GitHubAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { GitHubAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("viewer", Viewer.self),
    ] }

    /// The currently authenticated user.
    public var viewer: Viewer { __data["viewer"] }

    /// Viewer
    ///
    /// Parent Type: `User`
    public struct Viewer: GitHubAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { GitHubAPI.Objects.User }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("pullRequests", PullRequests.self, arguments: [
          "first": .variable("numResults"),
          "after": .variable("afterCursor")
        ]),
      ] }

      /// A list of pull requests associated with this user.
      public var pullRequests: PullRequests { __data["pullRequests"] }

      /// Viewer.PullRequests
      ///
      /// Parent Type: `PullRequestConnection`
      public struct PullRequests: GitHubAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { GitHubAPI.Objects.PullRequestConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("edges", alias: "pullRequests", [PullRequest?]?.self),
          .field("pageInfo", PageInfo.self),
        ] }

        /// A list of edges.
        public var pullRequests: [PullRequest?]? { __data["pullRequests"] }
        /// Information to aid in pagination.
        public var pageInfo: PageInfo { __data["pageInfo"] }

        /// Viewer.PullRequests.PullRequest
        ///
        /// Parent Type: `PullRequestEdge`
        public struct PullRequest: GitHubAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { GitHubAPI.Objects.PullRequestEdge }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("node", alias: "pullRequests", PullRequests?.self),
          ] }

          /// The item at the end of the edge.
          public var pullRequests: PullRequests? { __data["pullRequests"] }

          /// Viewer.PullRequests.PullRequest.PullRequests
          ///
          /// Parent Type: `PullRequest`
          public struct PullRequests: GitHubAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: any ApolloAPI.ParentType { GitHubAPI.Objects.PullRequest }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("author", Author?.self),
              .field("closed", Bool.self),
              .field("merged", Bool.self),
              .field("title", String.self),
              .field("url", GitHubAPI.URI.self),
              .field("baseRefName", String.self),
              .field("headRefName", String.self),
            ] }

            /// The actor who authored the comment.
            public var author: Author? { __data["author"] }
            /// `true` if the pull request is closed
            public var closed: Bool { __data["closed"] }
            /// Whether or not the pull request was merged.
            public var merged: Bool { __data["merged"] }
            /// Identifies the pull request title.
            public var title: String { __data["title"] }
            /// The HTTP URL for this pull request.
            public var url: GitHubAPI.URI { __data["url"] }
            /// Identifies the name of the base Ref associated with the pull request, even if the ref has been deleted.
            public var baseRefName: String { __data["baseRefName"] }
            /// Identifies the name of the head Ref associated with the pull request, even if the ref has been deleted.
            public var headRefName: String { __data["headRefName"] }

            /// Viewer.PullRequests.PullRequest.PullRequests.Author
            ///
            /// Parent Type: `Actor`
            public struct Author: GitHubAPI.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: any ApolloAPI.ParentType { GitHubAPI.Interfaces.Actor }
              public static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("login", String.self),
                .field("url", GitHubAPI.URI.self),
                .field("avatarUrl", GitHubAPI.URI.self),
              ] }

              /// The username of the actor.
              public var login: String { __data["login"] }
              /// The HTTP URL for this actor.
              public var url: GitHubAPI.URI { __data["url"] }
              /// A URL pointing to the actor's public avatar.
              public var avatarUrl: GitHubAPI.URI { __data["avatarUrl"] }
            }
          }
        }

        /// Viewer.PullRequests.PageInfo
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
}

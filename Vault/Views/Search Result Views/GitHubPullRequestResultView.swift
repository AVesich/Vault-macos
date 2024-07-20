//
//  GitHubPullRequestResultView.swift
//  Vault
//
//  Created by Austin Vesich on 7/19/24.
//

import SwiftUI

struct GitHubPullRequestResultView: View {
    
    @State private var isHovering: Bool = false
    public var pullRequestResult: GitHubPullRequestAPIResult
    
    var body: some View {
        HStack(alignment: .center, spacing: 16.0) {
            Image(systemName: "arrow.trianglehead.merge")
                .imageScale(.large)
            
            VStack(alignment: .leading, spacing: 4.0) {
                HStack(spacing: 0.0) {
                    Text(pullRequestResult.title)
                        .font(.manrope(12.0, weight: .bold))
                    Text(" by ")
                        .font(.manrope(12.0))
                    Text(pullRequestResult.authorUsername ?? "No author username found")
                        .font(.manrope(12.0, weight: .bold))
                        .padding(.trailing, 8.0)
                    
                    if let avatarURLString = pullRequestResult.authorAvatarURLString,
                       let avatarURL = URL(string: avatarURLString) {
                        AsyncImage(url: avatarURL) { result in
                            result.image?
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16.0, height: 16.0)
                                .clipShape(Circle())
                        }
                    } else {
                        Image(systemName: "person.fill")
                    }
                }
                Text(pullRequestResult.baseRefName + "    <-    " + pullRequestResult.headRefName)
                    .font(.manrope(24.0))
                    .padding(.bottom, 8.0)
            }
            
            Spacer()
            
            if isHovering {
                Image(systemName: "link")
            }
        }
        .padding(.top, 4.0)
        .animation(.spring(response: 0.25, dampingFraction: 0.55, blendDuration: 1.0), value: isHovering)
        .onHover { hovering in
            isHovering = hovering
        }
        .onTapGesture {
            if let url = URL(string: pullRequestResult.htmlURLString) {
                NSWorkspace.shared.open(url)
            }
        }
    }
}

#Preview {
    GitHubPullRequestResultView(pullRequestResult: GitHubPullRequestAPIResult(authorUsername: nil,
                                                                              authorAvatarURLString: nil,
                                                                              closed: false,
                                                                              merged: false,
                                                                              title: "New pull request",
                                                                              htmlURLString: "",
                                                                              baseRefName: "base",
                                                                              headRefName: "head"))
}

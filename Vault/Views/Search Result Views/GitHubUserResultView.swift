//
//  GitHubResult.swift
//  Vault
//
//  Created by Austin Vesich on 6/24/24.
//

import SwiftUI

struct GitHubUserResultView: View {
    
    @State private var isHovering: Bool = false
    public var userResult: GitHubUserSearchResult
    
    var body: some View {
        HStack(alignment: .center, spacing: 16.0) {
            if let avatarURL = URL(string: userResult.avatar_url) {
                AsyncImage(url: avatarURL) { result in
                    result.image?
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24.0, height: 24.0)
                        .clipShape(Circle())
                }
                .padding(.vertical, 8.0)
            }
            Text(userResult.login)
                .font(.manrope(18.0, weight: .regular))
            
            Spacer()
            
            if isHovering {
                Image(systemName: "link")
            }
        }
        .animation(.spring(response: 0.25, dampingFraction: 0.55, blendDuration: 1.0), value: isHovering)
        .onHover { hovering in
            isHovering = hovering
        }
        .onTapGesture {
            if let url = URL(string: userResult.html_url) {
                NSWorkspace.shared.open(url)
            }
        }
    }
}

#Preview {
    GitHubRepoResultView(repoResult: GitHubRepoSearchResult(id: 0,
                                                        name: "Test Repo",
                                                        owner: GitHubUser(login: "avesich",
                                                                          avatar_url: "https://avatars.githubusercontent.com/u/75646434?v=4"),
                                                                          html_url: "google.com"))
}

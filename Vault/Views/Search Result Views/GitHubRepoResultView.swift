//
//  GitHubResult.swift
//  Vault
//
//  Created by Austin Vesich on 6/24/24.
//

import SwiftUI

struct GitHubRepoResultView: View {
    
    @State private var isHovering: Bool = false
    public var repoResult: GitHubRepoSearchResult
    
    var body: some View {
        HStack(alignment: .center, spacing: 16.0) {
            Image(systemName: "externaldrive.connected.to.line.below.fill")
                .imageScale(.large)
            
            VStack(alignment: .leading, spacing: 4.0) {
                Text(repoResult.name)
                    .font(.manrope(24.0))
                HStack(spacing: 8.0) {
                    if let avatarURL = URL(string: repoResult.owner.avatar_url) {
                        AsyncImage(url: avatarURL) { result in
                            result.image?
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16.0, height: 16.0)
                                .clipShape(Circle())
                        }
                    }
                    Text(repoResult.owner.login)
                        .font(.manrope(12.0, weight: .bold))
                }
                .padding(.bottom, 8.0)
            }
            
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
            if let url = URL(string: repoResult.html_url) {
                NSWorkspace.shared.open(url)
            }
        }
    }
}

#Preview {
    GitHubRepoResultView(repoResult: GitHubRepoSearchResult(name: "Test Repo",
                                                            html_url: "google.com",
                                                            owner: GitHubUser(login: "avesich",
                                                                              avatar_url: "https://avatars.githubusercontent.com/u/75646434?v=4")))
}

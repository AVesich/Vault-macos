//
//  GitHubResult.swift
//  Vault
//
//  Created by Austin Vesich on 6/24/24.
//

import SwiftUI

struct GitHubUserResultView: View {
    
    public var userResult: GitHubUserAPIResult
    
    var body: some View {
        HStack(alignment: .center, spacing: 16.0) {
            if let avatarURL = URL(string: userResult.avatarURLString) {
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
                .font(.manrope(16.0))
            
            Spacer()
        }
    }
}

#Preview {
    GitHubRepoResultView(repoResult: GitHubRepoAPIResult(name: "Test Repo",
                                                         htmlURLString: "google.com",
                                                         ownerUsername: "avesich",
                                                         ownerAvatarURLString: "https://avatars.githubusercontent.com/u/75646434?v=4"))
}

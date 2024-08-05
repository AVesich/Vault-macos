//
//  GitHubResult.swift
//  Vault
//
//  Created by Austin Vesich on 6/24/24.
//

import SwiftUI

struct GitHubRepoResultView: View {
    
    public var repoResult: GitHubRepoAPIResult
    
    var body: some View {
        HStack(alignment: .center, spacing: 16.0) {
            Image(systemName: "externaldrive.connected.to.line.below.fill")
                .imageScale(.large)
            
            VStack(alignment: .leading, spacing: 4.0) {
                Text(repoResult.name)
                    .font(.manrope(24.0))
                HStack(spacing: 8.0) {
                    if let avatarURL = URL(string: repoResult.ownerAvatarURLString) {
                        AsyncImage(url: avatarURL) { result in
                            result.image?
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16.0, height: 16.0)
                                .clipShape(Circle())
                        }
                    }
                    Text(repoResult.ownerUsername)
                        .font(.manrope(12.0, weight: .bold))
                }
                .padding(.bottom, 8.0)
            }
            
            Spacer()
        }
        .onTapGesture {
            if let url = URL(string: repoResult.htmlURLString) {
                NSWorkspace.shared.open(url)
            }
        }
    }
}

#Preview {
    GitHubRepoResultView(repoResult: GitHubRepoAPIResult(name: "Test Repo",
                                                         htmlURLString: "google.com",
                                                         ownerUsername: "avesich",
                                                         ownerAvatarURLString: "https://avatars.githubusercontent.com/u/75646434?v=4"))
}

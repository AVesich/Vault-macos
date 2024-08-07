//
//  WebResultView.swift
//  Vault
//
//  Created by Austin Vesich on 7/2/24.
//

import SwiftUI

struct WebResultView: View {
    
    var urlString: String
    private let GOOGLE_API_URL = "https://www.google.com/s2/favicons?"
    private let GOOGLE_QUERY_URL = "https://www.google.com/search?q="
    private let API_FAVICON_SIZE: Int = 256
    private var imageURL: URL {
        if let iconURL = URL(string: GOOGLE_API_URL+"domain=\(urlString)"+"&sz=\(API_FAVICON_SIZE)") {
            return iconURL
        }
        return URL(string: GOOGLE_API_URL+"domain=google.com"+"&sz=\(API_FAVICON_SIZE)")!
    }

    var body: some View {
        HStack(spacing: 16.0) {
            AsyncImage(url: imageURL) { result in
                result.image?
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24.0, height: 24.0) // Display smaller than the requested icon size to prevent pixelated icons
            }
            .padding(.vertical, 8.0)
            Text(urlString.starts(with: GOOGLE_QUERY_URL) ? urlString.substring(32) : urlString) // Remove google url from a google suggestion
                .font(.manrope(16.0))
            
            Spacer()
        }
    }
}

#Preview {
    WebResultView(urlString: "github.com")
}

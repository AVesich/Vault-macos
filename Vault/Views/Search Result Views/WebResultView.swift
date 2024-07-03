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
    private let FAVICON_SIZE: Int = 24
    private var imageURL: URL {
        if let iconURL = URL(string: GOOGLE_API_URL+"domain=\(urlString)"+"&sz=\(FAVICON_SIZE)") {
            return iconURL
        }
        return URL(string: GOOGLE_API_URL+"domain=google.com"+"&sz=\(FAVICON_SIZE)")!
    }

    var body: some View {
        HStack(spacing: 8.0) {
            AsyncImage(url: imageURL) { content in
                content.image?
                    .resizable()
                    .scaledToFit()
                    .frame(width: CGFloat(FAVICON_SIZE), height: CGFloat(FAVICON_SIZE))
            }
            Text(urlString)
        }
    }
}

#Preview {
    WebResultView(urlString: "github.com")
}

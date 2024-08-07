//
//  FontResultVie.swift
//  Vault
//
//  Created by Austin Vesich on 6/9/24.
//

import SwiftUI

struct FontResultView: View {
    
    var font: NSFont
    
    var body: some View {
        HStack(alignment: .center, spacing: 16.0) {
            VStack(alignment: .leading, spacing: 4.0) {
                Text(font.fontName)
                    .lineLimit(1)
                    .font(.manrope(12.0, weight: .bold))
                    .padding(.leading, 16.0)
                Text("The quick brown fox runs over the lazy dog.")
                    .font(.custom(font.fontName, size: 24.0))
                    .frame(width: .infinity)
            }

            Spacer()
        }
        .padding(.vertical, 8.0)
    }
}

#Preview {
    FontResultView(font: NSFont(name: "Helvetica", size: 24.0)!)
}

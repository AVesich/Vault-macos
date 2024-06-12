//
//  ResultImage.swift
//  Vault
//
//  Created by Austin Vesich on 6/10/24.
//

import SwiftUI

struct ResultImage: View {
    
    @State private var hovering: Bool = false
    public var image: Image
    
    var body: some View {
        image
            .resizable()
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: 8.0))
            .scaleEffect(CGSize(width: hovering ? 1.05 : 1.0,
                                height: hovering ? 1.05 : 1.0))
            .onHover(perform: { hovering in
                self.hovering = hovering
            })
            .animation(.spring(response: 0.35, dampingFraction: 0.45, blendDuration: 0.5), value: hovering)
    }
}

#Preview {
    ResultImage(image: Image(systemName: "person.fill"))
}

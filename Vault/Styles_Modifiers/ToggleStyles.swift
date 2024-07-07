//
//  ToggleStyles.swift
//  Vault
//
//  Created by Austin Vesich on 5/23/24.
//

import SwiftUI

struct FavoriteStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Image(systemName: "star.fill")
            .foregroundStyle(configuration.isOn ? .yellow : .secondary)
            .onTapGesture {
                configuration.isOn.toggle()
            }
    }
}

extension ToggleStyle where Self == FavoriteStyle {
    static var favorite: FavoriteStyle { .init() }
}

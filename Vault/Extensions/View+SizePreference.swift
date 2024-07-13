//
//  ScrollViewSizeExtension.swift
//  Vault
//
//  Created by Austin Vesich on 6/19/24.
//

import Foundation
import SwiftUI

// From - https://stackoverflow.com/questions/68842004/how-do-i-make-a-swiftui-scroll-view-shrink-to-content

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct SizeModifier: ViewModifier {
    private var sizeView: some View {
        GeometryReader { geometry in
            Color.clear.preference(key: SizePreferenceKey.self, value: geometry.size)
        }
    }
    
    func body(content: Content) -> some View {
        content.overlay(sizeView)
    }
}

extension View {
    func getSize(perform: @escaping (CGSize) -> ()) -> some View {
        self.modifier(SizeModifier())
            .onPreferenceChange(SizePreferenceKey.self) { newValue in
                perform(newValue)
            }
    }
}

//
//  SettingsView.swift
//  Vault
//
//  Created by Austin Vesich on 8/5/24.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var selectedTab = 0
    
    var body: some View {
        if #available(macOS 15.0, *) {
            TabView(content: {
                Tab("Appearance", systemImage: "paintpalette") {
                    AppearanceSettingsView()
                }
            })
            .scenePadding()
            .frame(width: 350.0, height: 250.0)
        } else {
            // Fallback on earlier versions
        }
    }
}

#Preview {
    SettingsView()
}

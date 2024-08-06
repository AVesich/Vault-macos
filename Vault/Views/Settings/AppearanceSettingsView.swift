//
//  AppearanceSettingsView.swift
//  Vault
//
//  Created by Austin Vesich on 8/5/24.
//

import SwiftUI

struct AppearanceSettingsView: View {
    
    @AppStorage("backgroundColor") private var backgroundColor: Color = .clear
    @AppStorage("backgroundGlowAmount") private var backgroundGlowAmount: Double = 0.0
    
    var body: some View {
        VStack {
            HStack {
                Text("Background Color")
                Spacer()
                ColorPicker("", selection: $backgroundColor)
            }
            HStack {
                Text("Background Glow Radius")
                Spacer()
                Slider(value: $backgroundGlowAmount, in: 0...10)
            }
        }
    }
}

#Preview {
    AppearanceSettingsView()
}

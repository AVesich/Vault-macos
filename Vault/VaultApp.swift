//
//  VaultApp.swift
//  Vault
//
//  Created by Austin Vesich on 5/17/24.
//

import SwiftUI
import SwiftData
import CoreGraphics

final class AppDelegate: NSObject, NSApplicationDelegate {
        
    var hotkeyLoop: HotkeyLoop!
    
    internal func applicationDidFinishLaunching(_ notification: Notification) {
        prepareWindow()
        hotkeyLoop = HotkeyLoop()
    }
    
    private func prepareWindow() {
        if let window = NSApp.windows.first {
            removeStoplights(from: window)
            makeBackgroundClear(from: window)
        }
    }

    private func removeStoplights(from window: NSWindow) {
        // Hide stoplights
        window.standardWindowButton(.closeButton)!.isHidden = true
        window.standardWindowButton(.miniaturizeButton)!.isHidden = true
        window.standardWindowButton(.zoomButton)!.isHidden = true
    }

    private func makeBackgroundClear(from window: NSWindow) {
        // Make background clear
        window.backgroundColor = .clear
    }    
}

@main
struct VaultApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            DirectoryProfile.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    @State private var usingAI: Bool = false
    @State private var showAIGradient: Bool = false
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                RoundedRectangle(cornerRadius: 8.0)
                    .fill(.clear)
                    .frame(width: .infinity, height: .infinity)
                    .allowsHitTesting(false)
                                    
                MainSearch(usingAI: $usingAI)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16.0)
                            .fill(.clear)
                            .stroke(usingAI ? .purple : .clear, lineWidth: 8.0)
                            .clipShape(RoundedRectangle(cornerRadius: 16.0))
                    }
                    .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.65))
                    .onChange(of: usingAI) {
                        if usingAI {
                            activateAIChangeStates()
                        }
                    }
                    .shadow(color: showAIGradient ? .purple.opacity(0.0) : .purple, radius: showAIGradient ? 96.0 : 0.0)
                    .animation(showAIGradient ? .easeOut(duration: 0.5) : .none)
            }
        }
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
        .defaultPosition(.center)
        .modelContainer(sharedModelContainer)
    }
    
    private func activateAIChangeStates() {
        DispatchQueue.main.async {
            showAIGradient = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            showAIGradient = false
        }
    }
}

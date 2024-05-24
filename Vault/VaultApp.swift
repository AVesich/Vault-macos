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
        print("after")
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
            DirectoryConfig.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            MainSearch()
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .modelContainer(sharedModelContainer)
    }
}

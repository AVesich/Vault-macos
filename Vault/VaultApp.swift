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
                    .fill(.white)
                    .frame(width: .infinity, height: .infinity)
                    .allowsHitTesting(false)
                ZStack {
                    MainSearch(usingAI: $usingAI)
//                        .animation(.spring(response: 0.35, dampingFraction: 0.5, blendDuration: 1.0))
                        .overlay {
                            RoundedRectangle(cornerRadius: 16.0)
                                .fill(.clear)
                                .stroke(usingAI ? .purple : .clear, lineWidth: 8.0)
                                .shadow(color: .black.opacity(0.3), radius: 7.0)
                                .clipShape(RoundedRectangle(cornerRadius: 16.0))
                        }
                }
                .onChange(of: usingAI) {
                    if usingAI {
                        DispatchQueue.main.async {
                            showAIGradient = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            showAIGradient = false
                        }
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
}

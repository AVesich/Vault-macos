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
        
    var hotkeyLoop: HotkeyService!
    
    internal func applicationDidFinishLaunching(_ notification: Notification) {
        prepareWindow()
        hotkeyLoop = HotkeyService()
    }
    
    private func prepareWindow() {
        if let window = NSApp.windows.first {
            removeStoplights(from: window)
            makeBackgroundClear(from: window)
        }
    }

    private func removeStoplights(from window: NSWindow) {
        // Hide stoplights
        window.standardWindowButton(.closeButton)?.isHidden = true
        window.standardWindowButton(.miniaturizeButton)?.isHidden = true
        window.standardWindowButton(.zoomButton)?.isHidden = true
    }

    private func makeBackgroundClear(from window: NSWindow) {
        // Make background clear
        window.backgroundColor = .clear
    }    
}

@available(macOS 15.0, *)
@main
struct VaultApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @AppStorage("backgroundColor") private var backgroundColor: Color = .clear
    @State private var usingAI: Bool = false
    @State private var showAIGradient: Bool = false
    @State private var searchModel: GlobalSearch
    @State private var modeChanged: Bool = false
    let modelContainer: ModelContainer
    
    init () {
        do {
            modelContainer = try ModelContainer(for: Search.self)
            searchModel = GlobalSearch(modelContext: modelContainer.mainContext)
        } catch {
            fatalError("Failed to create model container.")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                RoundedRectangle(cornerRadius: 8.0)
                    .fill(.clear)
                    .frame(width: NSScreen.main!.visibleFrame.width, height: NSScreen.main!.visibleFrame.height)
                    .allowsHitTesting(false)
                                    
                MainSearch(usingAI: $usingAI)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16.0)
                            .fill(.clear)
                            .stroke(usingAI ? .purple : .clear, lineWidth: 6.0)
                            .clipShape(RoundedRectangle(cornerRadius: 16.0))
//                            .animation(.easeOut(duration: 0.15), value: usingAI)
                    }
                    .animation(.spring(response: 0.35, dampingFraction: 0.7, blendDuration: 0.3))
                    .onChange(of: searchModel.activeMode) {
                        if !(searchModel.activeMode.modeFilterType == .mode) {
                            activateModeChangeGradient()
                        }
                    }
                    .glow(color: backgroundColor)
                    .backgroundPulse(enabled: usingAI, color: .purple)
                    .backgroundPulse(enabled: modeChanged, color: .orange)
                    .sizePress(press: usingAI)
                    .shadow(color: (backgroundColor.shouldGlow()) ? .clear : .black.opacity(0.75),
                            radius: 25.0)
            }
            .environment(searchModel)
            .background { // Rectangle at the back of the stack is just meant to give something resizable to allow fullscreening, this actually is the background that allows defocus
                Color.black.opacity(0.0001).ignoresSafeArea()
//                    .onTapGesture {
//                        NSApp.hide(self)
//                    }
            }
            .onAppear {
                NSApplication.shared.windows.last?.setFrameOrigin(CGPoint(x: 0, y: 0))
            }
        }
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
        .defaultPosition(.center)
        .modelContainer(modelContainer)
        MenuBarExtra() {
            SettingsLink {
                Text("Settings")
            }
            Button("Show Window") {
            }
            Button("Quit Rockit") {
                NSApplication.shared.terminate(self)
            }
        } label: {
            Text("🚀")
        }
        Settings {
            SettingsView()
        }
    }
    
    private func activateModeChangeGradient() {
        DispatchQueue.main.async {
            modeChanged = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            modeChanged = false
        }
    }
}

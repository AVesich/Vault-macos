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

    @State private var usingAI: Bool = false
    @State private var showAIGradient: Bool = false
    @State private var searchModel: GlobalSearch
    @State private var showModeGradient: Bool = false
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
                    }
                    .animation(.spring(response: 0.35, dampingFraction: 0.75, blendDuration: 0.3))
                    .onChange(of: usingAI) {
                        if usingAI {
                            activateAIChangeGradient()
                        }
                    }
                    .onChange(of: searchModel.activeMode) {
                        if searchModel.activeMode != nil {
                            activateModeChangeGradient()
                        }
                    }
                    .shadow(color: showAIGradient ? .purple.opacity(0.0) : .purple, radius: showAIGradient ? 96.0 : 0.0)
                    .shadow(color: showModeGradient ? .red.opacity(0.0) : .red, radius: showModeGradient ? 96.0 : 0.0)
                    .animation(showAIGradient ? .easeOut(duration: 0.65) : .none, value: showAIGradient)
                    .animation(showModeGradient ? .easeOut(duration: 0.65) : .none, value: showModeGradient)
            }
            .environment(searchModel)
            .background { // Rectangle at the back of the stack is just meant to give something resizable to allow fullscreening, this actually is the background that allows defocus
                Color.black.opacity(0.0001).ignoresSafeArea()
                    .onTapGesture {
                        NSApp.hide(nil)
                    }
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
            Button("Show Window") {
            }
            Button("Quit Rockit") {
                NSApplication.shared.terminate(self)
            }
        } label: {
            Text("🚀")
        }
    }
    
    private func activateAIChangeGradient() {
        DispatchQueue.main.async {
            showAIGradient = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.65) {
            showAIGradient = false
        }
    }
    
    private func activateModeChangeGradient() {
        DispatchQueue.main.async {
            showModeGradient = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.65) {
            showModeGradient = false
        }
    }
}

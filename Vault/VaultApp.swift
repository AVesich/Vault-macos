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
    
    internal func applicationDidFinishLaunching(_ notification: Notification) {
        prepareWindow()
        setupSearchHotkey()
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
    
    private func setupSearchHotkey() {
        if let event = registerSearchHotkeyEvent() {
            startRunLoopForHotkeyEvent(event)
        } else {
            // TODO: - Show oops dialog
            fatalError("shits clapped")
        }
    }
    
    private func registerSearchHotkeyEvent() -> CFMachPort? {
        let buttonDownBitMask = 1 << CGEventType.keyDown.rawValue
        let buttonDownMask = CGEventMask(buttonDownBitMask)
        return CGEvent.tapCreate(tap: .cgSessionEventTap, place: .tailAppendEventTap, options: .defaultTap, eventsOfInterest: buttonDownMask, callback: checkButtonDownEventForOptS, userInfo: nil)
    }
    
    // For context, CFRunLoop is in charge of control & input dispatch for a task
    private func startRunLoopForHotkeyEvent(_ event: CFMachPort) {
        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, event, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: event, enable: true)
        CFRunLoopRun()
    }
}

func checkButtonDownEventForOptS(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
    let sPressed = event.getIntegerValueField(.keyboardEventKeycode) == 1
    let commandPressed = event.flags.contains(.maskAlternate)
    if type == .keyDown, sPressed, commandPressed {
        print("alt-s is working!")
    }
    return Unmanaged.passUnretained(event)
}

@main
struct VaultApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
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
            ContentView()
        }
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
        .modelContainer(sharedModelContainer)
    }
}

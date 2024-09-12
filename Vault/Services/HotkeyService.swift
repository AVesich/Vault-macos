//
//  HotkeyLoop.swift
//  Vault
//
//  Created by Austin Vesich on 5/18/24.
//

import CoreGraphics
import AppKit

class HotkeyService {
    
    init() {
        setupSearchHotkey()
    }
    
    private func setupSearchHotkey() {
        if let event = registerSearchHotkeyEvent() {
            print("setting up hotkey event")
            startRunLoopForHotkeyEvent(event)
        } else {
            // TODO: - Show oops dialog
            fatalError("Error setting up hotkey event")
        }
    }
    
    private func registerSearchHotkeyEvent() -> CFMachPort? {
        print("registering hotkey event")
        let buttonDownBitMask = 1 << CGEventType.keyDown.rawValue
        let buttonDownMask = CGEventMask(buttonDownBitMask)
        return CGEvent.tapCreate(tap: .cgSessionEventTap, place: .tailAppendEventTap, options: .defaultTap, eventsOfInterest: buttonDownMask, callback: checkButtonDownEventForOptS, userInfo: nil)
    }
    
    // For context, CFRunLoop is in charge of control & input dispatch for a task
    private func startRunLoopForHotkeyEvent(_ event: CFMachPort) {
        print("starting hotkey event loop")
        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, event, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: event, enable: true)
        CFRunLoopRun()
    }
}

func checkButtonDownEventForOptS(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
//    print("key pressed")
    let sPressed = event.getIntegerValueField(.keyboardEventKeycode) == 1
    let optionPressed = event.flags.contains(.maskAlternate)
    if type == .keyDown, sPressed, optionPressed {
        NSApp.activate(ignoringOtherApps: true)
        return nil
    }
    return Unmanaged.passUnretained(event)
}

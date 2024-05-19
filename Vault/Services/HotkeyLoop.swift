//
//  HotkeyLoop.swift
//  Vault
//
//  Created by Austin Vesich on 5/18/24.
//

import CoreGraphics

class HotkeyLoop {
    
    init() {
        setupSearchHotkey()
    }
    
    private func setupSearchHotkey() {
        if let event = registerSearchHotkeyEvent() {
            startRunLoopForHotkeyEvent(event)
        } else {
            // TODO: - Show oops dialog
            fatalError("Error setting up hotkey event")
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

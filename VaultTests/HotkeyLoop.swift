//
//  VaultTests.swift
//  VaultTests
//
//  Created by Austin Vesich on 5/17/24.
//

import XCTest
import Mockingbird
@testable import Vault

final class HotkeyLoopTests: XCTestCase {

    var hotkeyLoop: HotkeyLoop!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        hotkeyLoop = HotkeyLoop()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func buttonPressIsObserved() throws {
        given(checkButtonDownEventForOptS)
        
        let eventSource = CGEventSource(stateID: .privateState)
        if let sDown = CGEvent(keyboardEventSource: eventSource, virtualKey: 0x01, keyDown: true) {
            sDown.flags.insert(.maskCommand)
            
            let loc = CGEventTapLocation.cghidEventTap
            
            sDown.post(tap: loc)
        }
        
        verify(checkButtonDownEventForOptS).wasCalled(1)
        XCTAssertTrue(true)
    }
}

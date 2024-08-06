//
//  Color+RawRepresentable.swift
//  Vault
//
//  Created by Austin Vesich on 8/5/24.
//

// Based on https://medium.com/geekculture/using-appstorage-with-swiftui-colors-and-some-nskeyedarchiver-magic-a38038383c5e

import AppKit
import Foundation
import SwiftUI

extension Color: @retroactive RawRepresentable {
    
    public var rawValue: String {
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: NSColor(self), requiringSecureCoding: false) {
            return data.base64EncodedString()
        }
        return ""
    }
    
    public init? (rawValue dataString: String) {
        do {
            if let data = Data(base64Encoded: dataString),
               let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSColor.self, from: data) {
                self = Color(nsColor: color)
                return
            }
        } catch {}
        
        self = .clear
    }
}

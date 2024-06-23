//
//  AutofillTextField.swift
//  Vault
//
//  Created by Austin Vesich on 6/22/24.
//

import SwiftUI
import AppKit

struct AutofillTextField: NSViewRepresentable {
    
    @Binding var typedText: String
    var recommendedText: String
    var placeholderText: String
    // TODO: Add font?
    
    func makeNSView(context: Context) -> NSTextField {
        let textField = NSTextField()
        textField.placeholderString = placeholderText
        return textField
    }
    
    func updateNSView(_ nsView: NSTextField, context: Context) {
        nsView.stringValue = typedText
    }
}

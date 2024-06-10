//
//  GenerativeAI.swift
//  Vault
//
//  Created by Austin Vesich on 5/20/24.
//

import SwiftUI
import GoogleGenerativeAI

@Observable class GenerativeAI {
    private var apiKey: String {
        get {
            PlistHelper.getAPIPlistValue(forKey: "GoogleKey")
        }
    }
    private var model: GenerativeModel!
    public var response: String = ""
    
    init() {
        model = GenerativeModel(name: "gemini-pro", apiKey: apiKey)
    }
    
    public func getResponse(to prompt: String) async -> String {
        let response = try? await model.generateContent(prompt)
        return response?.text ?? "There is no response available at this time."
    }
}

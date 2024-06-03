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
            guard let filePath = Bundle.main.path(forResource: "AI", ofType: "plist") else {
                fatalError("Failed to find AI.plist")
            }
            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "GoogleKey") as? String else {
                fatalError("Couldn't find key 'GoogleKey' in 'AI.plist'.")
            }
            return value
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

//
//  WebEngine.swift
//  Vault
//
//  Created by Austin Vesich on 7/1/24.
//

import Foundation
import AppKit

final class WebEngine: Engine {
    public var delegate: EngineDelegate?
    public var specialAction: ((Int) -> ())? { openResultInGoogle }
//    public var enterAction: (() -> ())?// { openTopResultInGoogle }
    internal var API: WebAPI! = WebAPI(configFileName: "WebAPIConfig", apiHasURL: true)
    public let searchFilters = [SearchFilter]()
    
    private func openResultInGoogle(withIndex index: Int) {
        if let delegate = delegate as? WebEngineDelegate {
            delegate.openResultInGoogle(withIndex: index)
        }
    }
}

protocol WebEngineDelegate: EngineDelegate {
    func openResultInGoogle(withIndex: Int)
}

extension GlobalSearch: WebEngineDelegate {
    func openResultInGoogle(withIndex index: Int) {
        guard index < foundResults.count else {
            return
        }
        
        if let result = foundResults[index] as? WebResult,
           let url = URL(string: result.content) {
            NSWorkspace.shared.open(url)
        }
    }
}

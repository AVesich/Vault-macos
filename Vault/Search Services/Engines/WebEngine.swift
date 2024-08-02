//
//  WebEngine.swift
//  Vault
//
//  Created by Austin Vesich on 7/1/24.
//

import Foundation
import AppKit

class WebEngine: Engine {
    public var delegate: EngineDelegate?
    public var autocompleteMethod: (() -> ())?// { openTopResultInGoogle }
    internal var API: WebAPI! = WebAPI(configFileName: "WebAPIConfig", apiHasURL: true)
    public let searchFilters = [SearchFilter]()
}

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
    internal var API: WebAPI! = WebAPI(configFileName: "WebAPIConfig", apiHasURL: true)
    public let searchFilters = [SearchFilter]()
}

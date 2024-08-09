//
//  UnsplashSearchEngine.swift
//  Vault
//
//  Created by Austin Vesich on 6/9/24.
//

import Foundation

class UnsplashSearchEngine: Engine {
    public var delegate: EngineDelegate?
    internal var API: UnsplashAPI! = UnsplashAPI(configFileName: "UnsplashAPIConfig", apiHasURL: true, apiNeedsKey: true)
    public var searchFilters = [SearchFilter]()
}

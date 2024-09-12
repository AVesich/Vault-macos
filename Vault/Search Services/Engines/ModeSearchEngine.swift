//
//  ModeSearchEngine.swift
//  Vault
//
//  Created by Austin Vesich on 7/3/24.
//

class ModeSearchEngine: Engine {
    public var delegate: EngineDelegate?
    internal var API: ModeAPI! = ModeAPI(configFileName: "ModesConfig")
    public let searchFilters = [SearchFilter]()
}

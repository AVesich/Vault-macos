//
//  FileSystemSearchEngine.swift
//  Vault
//
//  Created by Austin Vesich on 6/2/24.
//

import Foundation
import CoreSpotlight
import AppKit

class FileSystemSearchEngine: Engine {

    // MARK: - Properties
    public var delegate: EngineDelegate?
    internal var API: FileSystemAPI! = FileSystemAPI(configFileName: "FilesConfig")
    public var searchFilters = [SearchFilter]()
}

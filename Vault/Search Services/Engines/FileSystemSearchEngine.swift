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
    internal var API: FileSystemAPI! = FileSystemAPI(configFileName: "FileSystemAPIConfig")
    public var searchFilters = [SearchFilter]()
    public var specialAction: ((Int) -> ())? { openFileInFinder }

    private func openFileInFinder(fromIndex index: Int) {
        if let delegate = delegate as? FileSystemSearchEngineDelegate {
            delegate.openFileInFinder(fromIndex: index)
        }
    }
}

protocol FileSystemSearchEngineDelegate: EngineDelegate {
    func openFileInFinder(fromIndex: Int)
}

extension GlobalSearch: FileSystemSearchEngineDelegate {
    func openFileInFinder(fromIndex index: Int) {
        guard index < foundResults.count else {
            return
        }
        
        if let result = foundResults[index] as? FileResult {
            NSWorkspace.shared.activateFileViewerSelecting([result.content])
        }
    }
}

//
//  File.swift
//  Vault
//
//  Created by Austin Vesich on 6/14/24.
//

import Foundation
import AppKit
import SwiftUI

// Uses the same code as FileSystemSearchEngine, but adds additional file extension comparison
class FontSearchEngine: Engine {
        
    // MARK: - Declaring properties
    public var delegate: EngineDelegate?
    public var enterAction: ((Int) -> ())? = nil
    internal var API: FontAPI! = FontAPI(configFileName: "FontAPIConfig")
        
    // MARK: - Mode & Filters
    public var searchFilters: [SearchFilter] {
        [SearchFilter(name: "Bold",
                      iconName: "bold",
                      selectAction: { [weak self] in self?.addTraitFilter(.boldFontMask) },
                      deselectAction: { [weak self] in self?.removeTraitFilter(.boldFontMask) }),
         SearchFilter(name: "Italic",
                      iconName: "italic",
                      selectAction: { [weak self] in self?.addTraitFilter(.italicFontMask) },
                      deselectAction: { [weak self] in self?.removeTraitFilter(.italicFontMask) }),
         SearchFilter(name: "Condensed",
                      iconName: "arrow.right.and.line.vertical.and.arrow.left",
                      selectAction: { [weak self] in self?.addTraitFilter(.condensedFontMask) },
                      deselectAction: { [weak self] in self?.removeTraitFilter(.condensedFontMask) }),
         SearchFilter(name: "Expanded",
                      iconName: "arrow.left.and.line.vertical.and.arrow.right",
                      selectAction: { [weak self] in self?.addTraitFilter(.expandedFontMask) },
                      deselectAction: { [weak self] in self?.removeTraitFilter(.expandedFontMask) }),
         SearchFilter(name: "Smallcaps",
                      iconName: "textformat.size.smaller",
                      selectAction: { [weak self] in self?.addTraitFilter(.smallCapsFontMask) },
                      deselectAction: { [weak self] in self?.removeTraitFilter(.smallCapsFontMask) })]
    }
    
    private func addTraitFilter(_ trait: NSFontTraitMask) {
        API.addTraitFilter(trait)
        API.resetQueryCache() // Prevent query staying the same and changing filters from thinking NEW pages should be loaded
        delegate?.engineRequestedResultsReset()
    }
    
    private func removeTraitFilter(_ trait: NSFontTraitMask) {
        API.removeTraitFilter(trait)
        API.resetQueryCache() // Prevent query staying the same and changing filters from thinking NEW pages should be loaded
        delegate?.engineRequestedResultsReset()
    }
}

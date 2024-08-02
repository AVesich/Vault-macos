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
    public var autocompleteMethod: (() -> ())? = nil
    internal var API: FontAPI! = FontAPI(configFileName: "FontAPIConfig")
        
    // MARK: - Mode & Filters
    public var searchFilters: [SearchFilter] {
        [SearchFilter(name: "Bold",
                      iconName: "bold",
                      selectAction: { [weak self] in self?.API.addTraitFilter(.boldFontMask) },
                      deselectAction: { [weak self] in self?.API.removeTraitFilter(.boldFontMask) }),
         SearchFilter(name: "Italic",
                      iconName: "italic",
                      selectAction: { [weak self] in self?.API.addTraitFilter(.italicFontMask) },
                      deselectAction: { [weak self] in self?.API.removeTraitFilter(.italicFontMask) }),
         SearchFilter(name: "Condensed",
                      iconName: "arrow.right.and.line.vertical.and.arrow.left",
                      selectAction: { [weak self] in self?.API.addTraitFilter(.condensedFontMask) },
                      deselectAction: { [weak self] in self?.API.removeTraitFilter(.condensedFontMask) }),
         SearchFilter(name: "Expanded",
                      iconName: "arrow.left.and.line.vertical.and.arrow.right",
                      selectAction: { [weak self] in self?.API.addTraitFilter(.expandedFontMask) },
                      deselectAction: { [weak self] in self?.API.removeTraitFilter(.expandedFontMask) }),
         SearchFilter(name: "Smallcaps",
                      iconName: "textformat.size.smaller",
                      selectAction: { [weak self] in self?.API.addTraitFilter(.smallCapsFontMask) },
                      deselectAction: { [weak self] in self?.API.removeTraitFilter(.smallCapsFontMask) })]
    }
    
    private func addTraitFilter(filter trait: NSFontTraitMask) {
        API.addTraitFilter(trait)
        delegate?.engineRequestedResultsReset()
    }
    
    private func removeTraitFilter(filter trait: NSFontTraitMask) {
        API.removeTraitFilter(trait)
        delegate?.engineRequestedResultsReset()
    }
}

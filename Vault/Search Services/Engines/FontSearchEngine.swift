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
    internal var searchResults = [SearchResult]()
    private var userQuery = NSMetadataQuery()
    private var systemQuery = NSMetadataQuery()
    private let MAX_RESULTS = 15 // TODO: Keep or remove
    
    // MARK: - Search Filters
    private var selectedTrait: NSFontTraitMask?
    public var searchFilters: [SearchFilter] {
        [SearchFilter(name: "Bold",
                      iconName: "bold",
                      selectAction: { [weak self] in self?.selectedTrait = .boldFontMask },
                      deselectAction: { [weak self] in self?.selectedTrait = nil }),
         SearchFilter(name: "Italic",
                      iconName: "italic",
                      selectAction: { [weak self] in self?.selectedTrait = .italicFontMask },
                      deselectAction: { [weak self] in self?.selectedTrait = nil }),
         SearchFilter(name: "Condensed",
                      iconName: "arrow.right.and.line.vertical.and.arrow.left",
                      selectAction: { [weak self] in self?.selectedTrait = .condensedFontMask },
                      deselectAction: { [weak self] in self?.selectedTrait = nil }),
         SearchFilter(name: "Expanded",
                      iconName: "arrow.left.and.line.vertical.and.arrow.right",
                      selectAction: { [weak self] in self?.selectedTrait = .expandedFontMask },
                      deselectAction: { [weak self] in self?.selectedTrait = nil }),
         SearchFilter(name: "Smallcaps",
                      iconName: "textformat.size.smaller",
                      selectAction: { [weak self] in self?.selectedTrait = .smallCapsFontMask },
                      deselectAction: { [weak self] in self?.selectedTrait = nil })]
    }
    
    // MARK: - Search Methods
    public func search(withQuery query: String, inActiveDirectory activeDirectory: String) {
        let fontNames = getFontNameResults(forQuery: query)
        
        let results: [SearchResult] = fontNames.compactMap {
            guard let font = NSFont(name: $0, size: 24.0) else {
                return nil
            }
            return SearchResult(font: font)
        }
        
        delegate?.engineDidFindResults(results: results)
    }
    
    private func getFontNameResults(forQuery query: String) -> [String] {
        let fontNames = selectedTrait==nil ? NSFontManager.shared.availableFonts : (NSFontManager.shared.availableFontNames(with: selectedTrait!) ?? [String]())
        var containingFonts = fontNames.compactMap { $0.contains(query) ? $0 : nil }
        containingFonts.sort {
            return $0.ranges(of: query)[0].lowerBound > $1.ranges(of: query)[0].lowerBound
        }
        return containingFonts
    }
}

protocol FontSearchEngineDelegate: EngineDelegate {}

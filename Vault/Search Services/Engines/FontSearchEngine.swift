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
    
    // MARK: - Font traits
    struct HashableFontTrait: Hashable {
        let trait: NSFontTraitMask
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(trait.rawValue)
        }
    }
    
    // MARK: - Declaring properties
    internal let name = "Fonts"
    public var delegate: EngineDelegate?
    internal var searchResults = [FontResult]() {
        didSet {
            delegate?.engineDidFindResults(results: searchResults)
        }
    }
    public var autocomplete: (() -> ())? = nil
    private var userQuery = NSMetadataQuery()
    private var systemQuery = NSMetadataQuery()
    private let MAX_RESULTS = 15 // TODO: Keep or remove
        
    // MARK: - Mode & Filters
    private var selectedTraits = Set<HashableFontTrait>()
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
    
    // MARK: - Methods
    private func addTraitFilter(_ trait: NSFontTraitMask) {
        selectedTraits.insert(HashableFontTrait(trait: trait))
    }
    
    private func removeTraitFilter(_ trait: NSFontTraitMask) {
        selectedTraits.remove(HashableFontTrait(trait: trait))
    }

    public func search(withQuery query: String, inActiveDirectory activeDirectory: String) {
        let fontNames = getFontNameResults(forQuery: query)
        
        let results: [FontResult] = fontNames.compactMap {
            guard let font = NSFont(name: $0, size: 24.0) else {
                return nil
            }
            return FontResult(content: font)
        }
        
        searchResults = results
    }
    
    private func getFontNameResults(forQuery query: String) -> [String] {
        guard !query.isEmpty else {
            return Array(getFilteredFontNames())
        }
        let lowerQuery = query.lowercased()
        
        var containingFonts = getFilteredFontNames().compactMap { $0.lowercased().contains(lowerQuery) ? $0 : nil }
        containingFonts.sort {
            return $0.lowercased().ranges(of: lowerQuery)[0].lowerBound > $1.lowercased().ranges(of: lowerQuery)[0].lowerBound
        }
        
        return containingFonts
    }
    
    private func getFilteredFontNames() -> Set<String> {
        if selectedTraits.isEmpty {
            return Set<String>(NSFontManager.shared.availableFonts)
        }
        
        var fontNames = Set<String>()
        for traitWrapper in selectedTraits {
            guard let fontNamesWithTrait = NSFontManager.shared.availableFontNames(with: traitWrapper.trait) else {
                continue
            }
            
            if fontNames.isEmpty { // We want to start with some results
                fontNames = Set<String>(fontNamesWithTrait)
            } else { // Multiple filters should show only fonts that satisfy all filters
                fontNames.formIntersection(fontNamesWithTrait)
            }
        }
        return fontNames
    }
}

protocol FontSearchEngineDelegate: EngineDelegate {}

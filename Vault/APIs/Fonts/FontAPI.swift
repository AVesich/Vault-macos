//
//  Fonts.swift
//  Vault
//
//  Created by Austin Vesich on 7/20/24.
//

import Foundation
import AppKit

final class FontAPI: API {
    
    struct HashableFontTrait: Hashable {
        let trait: NSFontTraitMask
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(trait.rawValue)
        }
    }
    
    // MARK: - Properties
    internal var apiConfig: APIConfig!
    internal var results = [any SearchResult]()
    internal var prevQuery: String? = nil
    internal var nextPageInfo: NextPageInfo<Int> = NextPageInfo<Int>(nextPageCursor: nil, hasNextPage: true)
    internal var isLoadingNewPage: Bool = false
    private var selectedTraits = Set<HashableFontTrait>()
    
    // MARK: - Initialization
    internal func postInitSetup() { }
    
    // MARK: - Methods
    public func addTraitFilter(_ trait: NSFontTraitMask) {
        selectedTraits.insert(HashableFontTrait(trait: trait))
    }
    
    public func removeTraitFilter(_ trait: NSFontTraitMask) {
        selectedTraits.remove(HashableFontTrait(trait: trait))
    }

    internal func getResultData(for query: String) async -> APIResponse<Int> {
        let fontNames = getFontNameResults(forQuery: query)
        
        var results: [FontResult] = fontNames.compactMap {
            guard let font = NSFont(name: $0, size: 24.0) else {
                return nil
            }
            return FontResult(content: font)
        }
        
        let startingIndexInt = nextPageInfo.nextPageCursor ?? 0 // Cursor isn't updated yet, so next cursor is start
        let endIndexInt = startingIndexInt+apiConfig.RESULTS_PER_PAGE
        let startingIndex = results.index(results.startIndex, offsetBy: startingIndexInt)
        let endingIndex = results.index(results.startIndex, offsetBy: endIndexInt)
        results = Array(results[startingIndex..<endingIndex])
        
        let hasResultsAvailable = endIndexInt < apiConfig.MAX_RESULTS
        let nextPageInfo = NextPageInfo(nextPageCursor: endIndexInt, hasNextPage: hasResultsAvailable)
        
        return APIResponse(results: results, nextPageInfo: nextPageInfo)
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

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
    internal var isReset: Bool = false
    internal var apiConfig: APIConfig!
//    internal var results = [any SearchResult]()
    internal var prevQuery: String? = nil
    internal var nextPageInfo: NextPageInfo<Int> = NextPageInfo<Int>(nextPageCursor: nil, hasNextPage: true)
    internal var isLoadingNewPage: Bool = false
    internal var loadedPageCount: Int = 0
    private var cachedFoundFontNames = Set<String>()
    private var selectedTraits = Set<HashableFontTrait>()
    
    // MARK: - Initialization
    internal func postInitSetup() { }
    
    // MARK: - "Overrides"
    public func resetQueryCache() {
        if isReset { // Multiple things can cause a reset, so this value is used to prevent 2x and 3x resets
            return
        }
        isReset = true
        
        // This is the only line different from the default implementation
        cachedFoundFontNames.removeAll()
        // End diff
        
        prevQuery = nil // Force next search to be new, not loading from a page
        nextPageInfo = NextPageInfo<PageCursorType>(nextPageCursor: nil, hasNextPage: true)
    }

    
    // MARK: - Methods
    public func addTraitFilter(_ trait: NSFontTraitMask) {
        selectedTraits.insert(HashableFontTrait(trait: trait))
    }
    
    public func removeTraitFilter(_ trait: NSFontTraitMask) {
        selectedTraits.remove(HashableFontTrait(trait: trait))
    }

    // ONLY GET NAMES OF FONTS WE HAVEN'T SEARCHED YET
    internal func getResultData(forQuery query: String) async -> APIResponse<Int> {
        guard nextPageInfo.hasNextPage else  {
            return APIResponse(results: [FontResult](), nextPageInfo: nextPageInfo)
        }
        let fontNames = getFontNameResults(forQuery: query)
        
        let maxIndex = fontNames.getMaxIndex(desiredIndexInt: apiConfig.RESULTS_PER_PAGE) // Get the end index of the results capped by the array size
        var foundResults = [FontResult]()
        var i = 0
        for fontName in fontNames where !cachedFoundFontNames.contains(fontName) {
            if i >= maxIndex {
                break
            }
            guard let font = NSFont(name: fontName, size: 24.0) else {
                continue
            }
            cachedFoundFontNames.insert(fontName)
            foundResults.append(FontResult(content: font))
            
            i+=1 // Only need to update this if we found a result, so continue statement above shouldn't be problematic
        }
        if !foundResults.isEmpty {
            loadedPageCount += 1
        }
        
        let hasNextPage = loadedPageCount < apiConfig.MAX_PAGE_COUNT && maxIndex == apiConfig.RESULTS_PER_PAGE // We can't hit max and can't be out of results
        let nextPageInfo = NextPageInfo<Int>(nextPageCursor: nil, hasNextPage: hasNextPage) // Next page cursor isn't used, since results are derived from unordered sets we use the cache for scrolling
        
        return APIResponse(results: foundResults, nextPageInfo: nextPageInfo)
    }
    
    private func getFontNameResults(forQuery query: String) -> [String] {
        guard !query.isEmpty else {
            return Array(getFilteredFontNames())
        }
        let lowerQuery = query.lowercased()
        
        var containingFonts = getFilteredFontNames().compactMap { $0.lowercased().contains(lowerQuery) ? $0 : nil }
        containingFonts.sort { // Sort by where the query first occurs
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

//
//  VaultTests.swift
//  VaultTests
//
//  Created by Austin Vesich on 5/17/24.
//

import XCTest
@testable import Vault

final class FileSystemSearchEngineTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    // MARK: - Basic results tests - Verified number of results
    // Test 0 results in empty folder
    func testAllResultsFoundEmptyFolder() async {
        let searchEngine = FileSystemSearchEngine(activeDirectory: "/Users/austin/Documents/Vault-macos/Sample-Directory/Dir-0-items/")
        let results = await searchEngine.search(withQuery: "")
        XCTAssertEqual(results.count, 0)
    }
    
    // Test 1 result in 1 item folder
    func testAllResultsFound1ItemFolder() async {
        let searchEngine = FileSystemSearchEngine(activeDirectory: "/Users/austin/Documents/Vault-macos/Sample-Directory/Dir-1-items/")
        let results = await searchEngine.search(withQuery: "")
        XCTAssertEqual(results.count, 1)
    }
    
    // Test 2 result in 2 item folder
    func testAllResultsFound2ItemFolder() async {
        let searchEngine = FileSystemSearchEngine(activeDirectory: "/Users/austin/Documents/Vault-macos/Sample-Directory/Dir-2-items/")
        let results = await searchEngine.search(withQuery: "")
        XCTAssertEqual(results.count, 2)
    }

    // Test 5 results in 5 item folder
    func testAllResultsFound5ItemFolder() async {
        let searchEngine = FileSystemSearchEngine(activeDirectory: "/Users/austin/Documents/Vault-macos/Sample-Directory/Dir-5-items/")
        let results = await searchEngine.search(withQuery: "")
        XCTAssertEqual(results.count, 5)
    }

    // Test 5 results in 6 item folder
    func testResultsCapped6ItemFolder() async {
        let searchEngine = FileSystemSearchEngine(activeDirectory: "/Users/austin/Documents/Vault-macos/Sample-Directory/Dir-6-items/")
        let results = await searchEngine.search(withQuery: "")
        XCTAssertEqual(results.count, 5)
    }
    
    // Test results in a folder full of folders
    func testFolderResultsInFolder() async {
        let searchEngine = FileSystemSearchEngine(activeDirectory: "/Users/austin/Documents/Vault-macos/Sample-Directory/")
        let results = await searchEngine.search(withQuery: "")
        XCTAssertEqual(results.count, 5)
    }
    
    // MARK: - Test recommendations
    func testSimilarityOneItem() async {
        let searchEngine = FileSystemSearchEngine(activeDirectory: "/Users/austin/Documents/Vault-macos/Sample-Directory/Dir-1-items/")
        let results = await searchEngine.search(withQuery: "Text")
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results[0].filePath!.lastPathComponent, "TextFile.txt")
    }
    
    func testSimilarityOneItemInMany() async {
        let searchEngine = FileSystemSearchEngine(activeDirectory: "/Users/austin/Documents/Vault-macos/Sample-Directory/Dir-6-items/")
        let results = await searchEngine.search(withQuery: "Text")
        XCTAssertEqual(results.count, 5)
        XCTAssertEqual(results[0].filePath!.lastPathComponent, "TextFile.txt")
    }
    
    func testSimilarityTwoItemsInMany() async {
        let searchEngine = FileSystemSearchEngine(activeDirectory: "/Users/austin/Documents/Vault-macos/Sample-Directory/Dir-5-items/")
        let results = await searchEngine.search(withQuery: "Fill")
        XCTAssertEqual(results.count, 5)
        XCTAssertTrue(results[0].filePath!.lastPathComponent.contains("Filler"))
        XCTAssertTrue(results[1].filePath!.lastPathComponent.contains("Filler"))
    }

    func testSimilarityThreeItemsInMany() async {
        let searchEngine = FileSystemSearchEngine(activeDirectory: "/Users/austin/Documents/Vault-macos/Sample-Directory/Dir-6-items/")
        let results = await searchEngine.search(withQuery: "Fill")
        XCTAssertEqual(results.count, 5)
        XCTAssertTrue(results[0].filePath!.lastPathComponent.contains("Filler"))
        XCTAssertTrue(results[1].filePath!.lastPathComponent.contains("Filler"))
        XCTAssertTrue(results[2].filePath!.lastPathComponent.contains("Filler"))
    }
}

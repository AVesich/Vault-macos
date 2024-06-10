//
//  TestFileSystemEngineDelegate.swift
//  VaultTests
//
//  Created by Austin Vesich on 6/9/24.
//

class TestFileSystemEngineDelegate: EngineDelegate {
    private var completionFunction: (([SearchResult]) -> ())!
    
    func setupCompletionFunction(_ completionFunction: @escaping ([SearchResult]) -> ()) {
        self.completionFunction = completionFunction
    }
    
    func engineDidFindResults(results: [SearchResult]) {
        completionFunction(results)
    }
}

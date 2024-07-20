//
//  TestFileSystemEngineDelegate.swift
//  VaultTests
//
//  Created by Austin Vesich on 6/9/24.
//

class TestFileSystemEngineDelegate: EngineDelegate {
    private var completionFunction: (([FileResult]) -> ())!
    
    func setupCompletionFunction(_ completionFunction: @escaping ([FileResult]) -> ()) {
        self.completionFunction = completionFunction
    }
    
    func engineGotResults(results: [any SearchResult]) {
        if let results = results as? [FileResult] {
            completionFunction(results)
        }
    }
}

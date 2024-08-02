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
    
    func engineRetrievedResults(newResults: [any SearchResult]) {
        if let results = newResults as? [FileResult] {
            completionFunction(results)
        }
    }
    
    func engineRequestedResultsReset() {
        return
    }
}
